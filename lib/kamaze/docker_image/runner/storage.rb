# frozen_string_literal: true

require_relative '../runner'

# Store commands to be executed.
#
# Command is shaped (formatted) on retrieval, using ``config``.
#
# @see #shape
# @see #config=
class Kamaze::DockerImage::Runner::Storage < Hash
  autoload :Cliver, 'cliver'

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

    key?(key) ? shape(val) : val
  end

  protected

  # @return [String]
  def executable
    Cliver.detect!('docker')
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
      .map { |w| w % config.merge(h) }
      .map { |w| w.to_s.empty? ? nil : w }
      .compact
      .map(&:to_s)
  end
end
