# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'
require 'docker'

# Runner provide methods to execute image related actions
#
# @see #actions
# @see Kamaze::DockerImage::Concern::Setup#default_commands
class Kamaze::DockerImage::Runner
  autoload :Shellwords, 'shellwords'

  require_relative 'runner/storage'

  # @return [Hash]
  attr_reader :config

  # Get commands
  #
  # @return [Hash]
  attr_reader :commands

  # @param [Kamaze::DockerImage] image
  #
  # @see Kamaze::DockerImage::Concern::Setup#default_commands
  def initialize(image)
    @config = image.to_h.freeze

    @commands = Storage[image.commands].tap do |store|
      store.config = @config
    end

    @commands.freeze
  end

  def build(&block)
    sh(*commands.fetch(:build), &block)
  end

  def run(command = nil, &block)
    cmd = commands.fetch(:run).push(command).compact

    sh(*cmd, &block)
  end

  def exec(command = nil, &block)
    command = Shellwords.split(command || image.exec_command)
    cmd = commands.fetch(:exec).push(*command)

    sh(*cmd, &block)
  end

  def start(&block)
    sh(*commands.fetch(:start), &block) unless running?
  end

  def stop(&block)
    sh(*commands.fetch(:stop), &block) if started?
  end

  def restart(&block)
    stop(&block)
    start(&block)
  end

  # @return [Array<Symbol>]
  def actions
    %i[restart start stop exec run build].sort
  end

  # Denote container is started.
  #
  # @return [Boolean]
  def started?
    !fetch_containers.empty?
  end

  # Denote container is running.
  #
  # @return [Boolean]
  def running?
    !fetch_containers(:running).empty?
  end

  protected

  # Fetch containers
  #
  # @param states [Array|nil] states
  # @return [Array<Docker::Container>]
  def fetch_containers(states = nil)
    unless states.nil?
      states = (states.is_a?(Array) ? states : [states]).map(&:to_s)
      states = nil if states.empty?
    end

    Docker::Container.all(all: true).keep_if do |c|
      states.to_a.empty? ? true : states.include?(c.info.fetch('State'))
    end.keep_if do |c|
      c.info.fetch('Names').include?("/#{config.fetch(:run_as)}")
    end
  end

  # @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
  def sh(*cmd, &block)
    options = cmd.last.is_a?(Hash) ? cmd.pop : {}
    options[:verbose] = config[:verbose] unless options.key?(:verbose)

    Class.new do
      require 'rake'
      require 'rake/file_utils'

      include FileUtils
    end.new.sh(*cmd.map(&:to_s).push(options), &block)
  end
end
