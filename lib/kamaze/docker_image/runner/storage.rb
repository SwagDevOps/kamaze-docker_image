# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../runner'

# Store commands to be executed.
#
# Command is shaped (formatted) on retrieval, using ``config``.
#
# @see #shape
# @see #config=
class Kamaze::DockerImage::Runner::Storage < Hash
  include(Kamaze::DockerImage::Concern::Executable)

  # @param [Hash] config
  def config=(config)
    @config = config.clone.freeze
  end

  # @return [Hash]
  def config
    @config.to_h
  end

  # Retrieves the value object corresponding to the key object.
  #
  # @return [Array<String>]
  def [](key)
    self.fetch(key)
  rescue KeyError
    super
  end

  # Returns a value from the hash for the given key.
  #
  # @raise [KeyError]
  # @return [Array<String>]
  def fetch(key)
    key = key.to_sym
    val = super

    val ? shape(val) : val
  end

  protected

  # Get executable
  #
  # @raise [Cliver::Dependency::NotFound]
  # @return [String]
  def executable
    config[:docker_bin] || super
  end

  # Format given command
  #
  # @param [Array] command
  # @return [Array<String>]
  def shape(command)
    # rubocop:disable Style/TernaryParentheses
    h = {
      opt_it: ($stdout.tty? and $stderr.tty?) ? '-it' : nil,
    }
    # rubocop:enable Style/TernaryParentheses

    [executable]
      .push(*command)
      .map(&:to_s)
      .map { |w| w % config.merge(h) }
      .map { |w| w.to_s.empty? ? nil : w }
      .compact
  end
end
