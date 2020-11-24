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

  # List containers.
  #
  # Containers are indexed by name.
  #
  # @return [Hash{String => Hash}]
  def containers(all: true) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity
    [(config[:docker_bin] || executable).to_s].map(&:freeze).freeze.yield_self do |cmd|
      cmd.dup.concat(['ps', (all ? '-a' : nil), '--format', '{{json .}}']).yield_self do |command|
        [].tap do |items|
          Open3.capture3(*command.compact).yield_self do |stdout, _, status|
            stdout.lines.each { |line| items.push(JSON.parse(line)) } if status.success?
          end
        end
      end.map do |h|
        cmd.dup.concat(['inspect', '--format', '{{json .}}', h.fetch('ID')]).yield_self do |command|
          Open3.capture3(*command.compact).yield_self do |stdout, _, status|
            h.tap do
              h.singleton_class.tap do |klass|
                klass.__send__(:define_method, :info) { (status.success? ? JSON.parse(stdout) : nil).to_h }
                klass.__send__(:define_method, :running?) { info['State'].to_h['Status'] == 'running' }
              end
            end
          end
        end
      end.map { |h| [h.info['Name'].gsub(%r{^/*}, '').to_s, h] }.to_h
    end
  end
end
