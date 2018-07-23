# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'
require_relative 'concern/docker'
autoload :YAML, 'yaml'
autoload :Pathname, 'pathname'
autoload :Cliver, 'cliver'

# Runner provide methods to connect into image using ssh.
#
# Sample of use:
#
# ```ruby
# require 'kamaze/docker_image'
#
# ssh = Kamaze::DockerImage::SSH.new(run_as: 'kamaze_sample_image')
# ```
class Kamaze::DockerImage::SSH
  include Kamaze::DockerImage::Concern::Docker

  Command = Kamaze::DockerImage::Command

  # @return [Hash]
  attr_reader :config

  # @param [Kamaze::DockerImage] image
  #
  # @see Kamaze::DockerImage::Concern::Setup#default_commands
  def initialize(image)
    @config = { ssh: image.to_h[:ssh].to_h.merge(defaults) }.merge(image.to_h)
  end

  # @raise [Errno::ENONET]
  def call(&block)
    raise Errno::ENONET unless network?

    command.run(&block)
  end

  # Get defaults for config.
  #
  # @return [Hash{Symbol => Object}]
  def defaults
    YAML.safe_load(Pathname.new(__dir__).join('ssh.yml').read, [Symbol])
  end

  # @return [Command]
  def command
    command = config.fetch(:ssh).fetch(:command).map { |w| w % params }

    Command.new(command, config)
  end

  # Params used to shape command.
  #
  # @return [Hash{Symbol => Object}]
  def params
    {
      executable: executable,
      port: config.fetch(:ssh).fetch(:port),
      user: config.fetch(:ssh).fetch(:user),
      host: network.fetch(0)
    }
  end

  # Get absolute path for executable.
  #
  # @return [String|Object]
  def executable
    config.fetch(:ssh).fetch(:executable).tap do |executable|
      Cliver.detect(executable).tap do |s|
        return (s || executable).freeze
      end
    end
  end

  # Denote SSH is enabled.
  #
  # @return [Boolean]
  def enabled?
    config.fetch(:ssh)[:enabled]
  end

  # Get ip addresses.
  #
  # @return [Array<String>]
  def network
    container = fetch_containers(config.fetch(:run_as), [:running])[0]

    return [] if container.nil?

    container.info['NetworkSettings']['Networks']
             .to_a
             .keep_if { |row| row[1].to_h['IPAddress'] }
             .map { |row| row[1]['IPAddress'] }
             .compact
  end

  # @return [Boolean]
  def network?
    !network.empty?
  end
end