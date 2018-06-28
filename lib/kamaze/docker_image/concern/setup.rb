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

  protected

  # Setup
  #
  # @param [Array<Thread::Backtrace::Location>] locations
  def setup(locations, &block)
    setup_defaults(locations)
    setup_block(&block) if block

    @name = @name.to_s
    @commands = Hash[@commands.map { |k, v| [k.to_sym, v] }]
    to_h.each { |k, v| instance_variable_set("@#{k}", v) }
  end

  # Setup atttributes with default values
  #
  # @param [Array<Thread::Backtrace::Location>] locations
  def setup_defaults(locations)
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

  def setup_block(&_block)
    os = OpenStruct.new
    yield(os)

    os.to_h.each do |k, v|
      begin
        __send__("#{k}=", v)
      rescue NoMethodError
        next
      end
    end
  end

  # @return [Pathname]
  def called_from(locations = caller_locations)
    location = locations.first.path

    Pathname.new(location).realpath
  end

  # @return [Hash]
  def default_commands
    {
      build: ['build', '--tag', '%<image>s', '--rm', '%<path>s'],
      exec: ['exec', '%<opt_it>s', '%<run_as>s'],
      run: ['run', '%<opt_it>s', '%<image>s'],
      start: ['run', '-d', '--name', '%<run_as>s', '%<image>s'],
      stop: ['rm', '-f', '%<run_as>s']
    }
  end
end
