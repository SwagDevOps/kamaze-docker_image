# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provide containers method.
module Kamaze::DockerImage::Concern::Containers
  include Kamaze::DockerImage::Concern::Executable

  autoload(:Open3, 'open3')
  autoload(:JSON, 'json')

  protected

  # rubocop:disable Metrics/AbcSize, Metrics/MethodLength

  # List containers.
  #
  # Containers are indexed by name.
  #
  # @return [Hash{String => Hash}]
  def containers(all: true)
    [(config[:docker_bin] || executable).to_s].map(&:freeze).freeze.yield_self do |cmd|
      cmd.dup.concat(['ps', (all ? '-a' : nil), '--format', '{{json .}}']).yield_self do |command|
        [].tap do |items|
          Open3.capture3(*command.compact).yield_self do |stdout, _, status|
            stdout.lines.each { |line| items.push(JSON.parse(line)) } if status.success?
          end
        end
      end.map { |h| containers_maker.call(h) }.map { |h| [h.info['Name'].gsub(%r{^/*}, '').to_s, h] }.to_h
    end
  end

  # Add some methods on retrieved info.
  #
  # @api private
  #
  # @return [Proc}
  def containers_maker
    # @type [Hash{String => Object}] given_data
    lambda do |given_data|
      command = [(config[:docker_bin] || executable).to_s]
                .map(&:freeze)
                .concat(['inspect', '--format', '{{json .}}', given_data.fetch('ID')])

      given_data.dup.tap do |result|
        result.singleton_class.tap do |klass|
          :inspection.tap do |method_name|
            klass.__send__(:define_method, method_name) do
              -> { Struct.new(:stdout, :stderr, :status).new(*Open3.capture3(*command.compact)) }
            end
            klass.__send__(:protected, method_name)
          end

          klass.__send__(:define_method, :info) do
            inspection.call.yield_self do |v|
              (v.status.success? ? JSON.parse(v.stdout) : nil).to_h
            end
          end

          klass.__send__(:define_method, :running?) do
            self.info['State'].to_h['Status'] == 'running'
          end
        end
      end.freeze
    end
  end

  # rubocop:enable Metrics/AbcSize, Metrics/MethodLength
end
