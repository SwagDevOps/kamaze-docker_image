# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

# rubocop:disable Style/Documentation

module Kamaze
end

# rubocop:enable Style/Documentation

# Describe a docker image
class Kamaze::DockerImage
  # Get commands
  #
  # Commands as run by runner
  #
  # @see Kamaze::DockerImage::Runner#command
  # @see Kamaze::DockerImage::Concern::Setup#default_commands
  #
  # @return [Hash]
  attr_reader :commands

  # Get image name
  #
  # @return [String]
  attr_reader :name

  # Get version
  #
  # @return [String]
  attr_reader :version

  # Get namespace used for tasks
  #
  # @return [String|Symbol|nil]
  attr_reader :tasks_ns

  # Get name used to run container
  #
  # @return [String]
  attr_reader :run_as

  # Get default command for ``exec``
  #
  # @see Runner#exec
  #
  # @return [String]
  attr_reader :exec_command

  autoload :Pathname, 'pathname'

  autoload :Runner, "#{__dir__}/docker_image/runner"
  autoload :Loader, "#{__dir__}/docker_image/loader"
  autoload :VERSION, "#{__dir__}/docker_image/version"

  [:setup, :readable_attrs].each do |req|
    require_relative "#{__dir__}/docker_image/concern/#{req}"
  end

  include Concern::Setup
  include Concern::ReadableAttrs

  def initialize(&block)
    setup(caller_locations, &block)

    @runner = Runner.new(self)
    tasks_load! if tasks_load?
  end

  # Denote image is running/started
  #
  # @return [Boolean]
  def started?
    runner.started?
  end

  alias running? started?

  def to_s
    "#{name}:#{version}"
  end

  # @return [Boolean]
  def verbose?
    !!@verbose
  end

  # @return [Boolean]
  def tasks_load?
    !!@tasks_load
  end

  # @return [Pathname]
  def path
    Pathname.new(@path)
  end

  # @see Runner#actions
  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      return runner.public_send(method, *args, &block)
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    flag = (runner&.actions).to_a.include?(method.to_sym)

    flag || super(method, include_private)
  end

  protected

  # @type [String]
  attr_writer :name

  # @see Concern::Setup#setup_defaults
  # @type [String]
  attr_writer :path

  # @see Concern::Setup#setup_defaults
  # @type [Boolean]
  attr_writer :verbose

  # @see Concern::Setup#setup_defaults
  # @type [String]
  attr_writer :version

  # @type [String|nil]
  attr_writer :tasks_ns

  # @see Concern::Setup#setup_defaults
  # @type [String]
  attr_writer :tasks_load

  # @see Concern::Setup#setup_defaults
  # @type [String]
  attr_writer :run_as

  # @see Concern::Setup#setup_defaults
  # @type [String]
  attr_writer :exec_command

  # @see Concern::Setup#setup_defaults
  # @type [Hash]
  attr_writer :commands

  # @return [Runner]
  attr_reader :runner

  # Load tasks
  def tasks_load!
    Loader.new(self).call

    self
  end
end
