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
  autoload :Storage, "#{__dir__}/runner/storage"
  autoload :Command, "#{__dir__}/runner/command"

  # @param [Kamaze::DockerImage] image
  #
  # @see Kamaze::DockerImage::Concern::Setup#default_commands
  def initialize(image)
    @config = image.to_h.reject! { |k| k == :commands }.freeze
    @commands = Storage[image.commands].tap do |store|
      store.config = @config
    end

    @commands.freeze
  end

  def build(&block)
    command(:build).run(&block)
  end

  def run(extra = nil, &block)
    command(:run, extra).run(&block)
  end

  def exec(extra = nil, &block)
    default = config.fetch(:exec_command)
    extra ||= default

    command(:exec, extra).run(&block)
  end

  def start(&block)
    command(:start).run(&block) unless running?
  end

  def stop(&block)
    command(:stop).run(&block) if started?
  end

  def rm(&block)
    command(:rm).run(&block) if started?
  end

  def restart(&block)
    stop(&block)
    rm(&block)
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

  # @return [Hash]
  attr_reader :config

  # Get commands
  #
  # @return [Hash]
  attr_reader :commands

  # Generate command.
  #
  # @param [String|Symbol] name
  # @param [String|nil] extra
  # @return [Command]
  def command(name, extra = nil)
    command = commands.fetch(name.to_sym)

    Command.new(command, config, extra)
  end

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
end
