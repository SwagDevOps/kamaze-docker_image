# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'

# Describe a command
#
# Command is able to run itself.
class Kamaze::DockerImage::Command
  autoload :Shellwords, 'shellwords'

  # @return [Hash]
  attr_reader :config

  # @param [Array<String>] command
  # @param [Hash] config
  # @param [String|nil] extra
  def initialize(command, config = {}, extra = nil)
    command.clone.to_a.tap do |c|
      extras = Shellwords.split(extra.to_s).compact
      @parts = c.push(*extras).freeze
    end

    config.clone.to_h.tap do |c|
      @config = c.freeze
    end
  end

  # @return [Array<String>]
  def to_a
    parts.clone
  end

  # @return [String]
  def to_s
    Shellwords.join(self.to_a)
  end

  def run(&block)
    sh(*self.to_a, &block)
  end

  alias call run

  # @return [Boolean]
  def execute
    system(*self.to_a)
  end

  protected

  # @return [Array<String>]
  attr_reader :parts

  # Get utils.
  #
  # return [Class]
  def utils
    if Gem::Specification.find_all_by_name('rake')
      require 'rake'
      require 'rake/file_utils'
    end

    Class.new { include FileUtils }.new
  end

  # @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
  def sh(*cmd, &block)
    options = cmd.last.is_a?(Hash) ? cmd.pop : {}
    options[:verbose] = config[:verbose] unless options.key?(:verbose)

    utils.sh(*cmd.map(&:to_s).push(options), &block)
  end
end
