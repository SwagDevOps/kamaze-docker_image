# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides setup (used during initialization) and related methods.
module Kamaze::DockerImage::Concern::Setup
  autoload :OpenStruct, 'ostruct'
  autoload :Pathname, 'pathname'
  autoload :YAML, 'yaml'

  protected

  # Setup
  #
  # @param [Array<Thread::Backtrace::Location>] locations
  # @return [self]
  def setup(locations, &block)
    setup_defaults(locations).tap do
      setup_block(&block)

      @name = @name.to_s
      @commands = Hash[@commands.map { |k, v| [k.to_sym, v] }]

      to_h.each { |k, v| instance_variable_set("@#{k}", v) }
    end
  end

  # rubocop:disable Metrics/MethodLength

  # Setup atttributes with default values
  #
  # @param [Array<Thread::Backtrace::Location>] locations
  # @return [self]
  def setup_defaults(locations)
    self.tap do
      @name = nil
      @version = 'latest'

      @path = Pathname.new('.')
      @verbose = $stdout.tty? && $stderr.tty?
      @tasks_load = true
      @tasks_ns = nil
      @run_as = called_from(locations).dirname.basename.to_s
      @docker_bin = 'docker'
      @exec_command = 'bash'
      @commands = default_commands
    end
  end

  # rubocop:enable Metrics/MethodLength

  # @yield [OpenStruct] config used to setup instance
  # @return [OpenStruct]
  def setup_block
    OpenStruct.new(self.respond_to?(:to_h) ? to_h : {}).tap do |s|
      yield(s) if block_given?

      s.freeze
      s.to_h.each { |k, v| setup_attr(k, v) }
    end
  end

  # Get default commands
  #
  # @return [Hash]
  def default_commands
    content = Pathname.new(__dir__).join('..', 'commands.yml').read

    YAML.safe_load(content, [Symbol])
  end

  private

  # Set given attr with given value
  #
  # @param [String|Symbol] attr
  # @param [Object] val
  def setup_attr(attr, val)
    __send__("#{attr}=", val)
  rescue NoMethodError
    nil
  end

  # @return [Pathname]
  def called_from(locations = caller_locations)
    location = locations.first.path

    Pathname.new(location).realpath
  end
end
