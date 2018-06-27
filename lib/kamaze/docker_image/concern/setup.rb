# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'
require 'pathname'

# Provides setup (used during initialization) and related methods.
module Kamaze::DockerImage::Concern::Setup
  protected

  # Setup atttributes with default values
  #
  # @param [Array<Thread::Backtrace::Location>] locations
  def setup(locations)
    @name = nil
    @verbose = $stdout.tty? && $stderr.tty?
    @tasks_load = true
    @tasks_ns = nil
    @run_as = called_from(locations).dirname.basename.to_s
    @exec_command = 'bash'
    @commands = default_commands
  end

  # @return [Pathname]
  def called_from(locations = caller_locations)
    location = locations.first.path

    Pathname.new(location).realpath
  end

  # @return [Hash]
  def default_commands
    {
      build: ['build', '%<opt_t>s', '%<name>s:%<version>s', '--rm', '%<path>s'],
      exec: ['exec', '%<opt_it>s', '%<run_as>s'],
      run: ['run', '%<opt_it>s', '%<name>s:%<version>s'],
      start: ['run', '-d', '--name', '%<run_as>s', '%<name>s:%<version>s'],
      'started?': ['inspect', '-f', '{{.State.Running}}', '%<run_as>s'],
      stop: ['rm', '-f', '%<run_as>s']
    }
  end
end
