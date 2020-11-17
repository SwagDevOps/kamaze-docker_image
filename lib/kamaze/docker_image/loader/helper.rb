# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../loader'

# Helper for tasks.
#
# Sample of use:
#
# ```ruby
# helper = Kamaze::DockerImage::Loader::Helper.new(image)
#
# desc 'Run a command in a new container'
#
# task helper.appoint(:run), [:command] do |task, args|
#   helper.call(task, args) { image.run(args[:command]) }
# end
# ````
class Kamaze::DockerImage::Loader::Helper
  # @param [Kamaze::DockerImage] image
  def initialize(image)
    @image = image
  end

  # Make task name using namespace (from image)
  #
  # @return [String]
  def appoint(name)
    namer.call(name)
  end

  # Execute related ``pre_`` and ``post_`` tasks
  #
  # @param [Rake::Task] task
  # @param [Hash{Symbol => Object}] args
  #
  # Sample of use:
  #
  # ```ruby
  # task 'docker:pre_start' do |task, args|
  #   pp(task, args)
  # end
  #
  # task 'docker:post_start' do |task, args|
  #   pp(task, args)
  # end
  # ```
  def wrap(task, args, &block)
    on_pre(task, args)
    block.call
    on_post(task, args)
  end

  alias call wrap

  protected

  # @return [Kamaze::DockerImage]
  attr_accessor :image

  # @return [Proc]
  def namer
    lambda do |name|
      "#{image.tasks_ns}:#{name}".gsub(/^:/, '')
    end
  end

  # @param [Rake::Task] task
  def on_pre(task, args)
    task_call(on: :pre, from: task, args: args)
  end

  # @param [Rake::Task] task
  def on_post(task, args)
    task_call(on: :post, from: task, args: args)
  end

  # Call pre/post tasks.
  #
  # on: pre/post
  # from: task as ``Rake::Task``
  # args: Hash
  def task_call(on:, from:, args:)
    cname = from.name.gsub(/^#{image.tasks_ns}:/, '')
    # @formatter:off
    {
      pre: namer.call("pre_#{cname}"),
      post: namer.call("post_#{cname}"),
    }.fetch(on).tap do |name|
      Rake::Task[name].execute(**args.to_h) if Rake::Task.task_defined?(name)
    end
    # @formatter:on
  end
end
