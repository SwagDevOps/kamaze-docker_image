# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'
require_relative 'concern/docker'

# Runner provide methods to execute image related actions
#
# @see #actions
# @see Kamaze::DockerImage::Concern::Setup#default_commands
class Kamaze::DockerImage::Runner
  include Kamaze::DockerImage::Concern::Docker

  Command = Kamaze::DockerImage::Command

  # Available actions
  #
  # Actions registrable on ``image``.
  # @see Runner#actions
  ACTIONS = %i[restart start stop exec run build push rm rebuild].sort

  autoload :Storage, "#{__dir__}/runner/storage"

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

  # Build image
  def build(&block)
    command(:build).run(&block)
  end

  # Push image
  def push(&block)
    command(:push).run(&block)
  end

  # Build image (do not use cache)
  def rebuild(&block)
    command(:rebuild).run(&block)
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
    ACTIONS
  end

  # Denote container is started.
  #
  # @return [Boolean]
  def started?
    !fetch_containers(config.fetch(:run_as)).empty?
  end

  # Denote container is running.
  #
  # @return [Boolean]
  def running?
    !fetch_containers(config.fetch(:run_as), :running).empty?
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
end
