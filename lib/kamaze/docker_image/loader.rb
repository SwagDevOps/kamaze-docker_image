# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'

# Loader for tasks (using eval binding)
class Kamaze::DockerImage::Loader
  autoload :Pathname, 'pathname'
  autoload :Context, "#{__dir__}/loader/context"
  autoload :Helper, "#{__dir__}/loader/helper"

  # @param [Kamaze::DockerImage] image
  def initialize(image)
    @image = image.clone.freeze
  end

  # Load tasks.
  #
  # @return [self]
  def call
    return self unless loadable?

    self.tap do
      context.call do |b|
        b.local_variable_set(:helper, Helper.new(image))
        b.local_variable_set(:image, image)
        # @todo add a lister for tasks -------------------------------
        b.local_variable_set(:tasks_dir, tasks_dir)
        b.eval(content)
      end
    end
  end

  # @return [Boolean]
  def loadable?
    context.dsl?
  end

  protected

  # @return [Kamaze::DockerImage]
  attr_reader :image

  # @return [Pathname]
  def file
    Pathname.new(__dir__).join('loader', 'tasks.rb')
  end

  # Tasks file content (to eval)
  #
  # @return [String]
  def content
    file.read
  end

  # @return [Module<Context>]
  def context
    Context
  end

  # @return [Pathname]
  def tasks_dir
    Pathname.new(__dir__).join('loader', 'tasks')
  end
end
