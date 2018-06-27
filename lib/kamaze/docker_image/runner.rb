# frozen_string_literal: true

require_relative '../docker_image'

# Runner provide methods to execute image related actions
#
# @see #actions
# @see Kamaze::DockerImage::Concern::Setup#default_commands
class Kamaze::DockerImage::Runner
  autoload :YAML, 'yaml'
  autoload :Open3, 'open3'
  autoload :Shellwords, 'shellwords'

  require_relative 'runner/storage'

  # @return [Hash]
  attr_reader :config

  # Get commands
  #
  # @return [Hash]
  attr_reader :commands

  # @param [Kamaze::DockerImage] image
  #
  # @see Kamaze::DockerImage::Concern::Setup#default_commands
  def initialize(image)
    @config = image.to_h.freeze

    image.commands.merge(default_commands).tap do |commands|
      @commands = Storage[commands].tap do |store|
        store.config = @config
      end
    end

    @commands.freeze
  end

  # @return [Hash]
  def default_commands
    {
      'started?': ['inspect', '-f', '{{.State.Running}}', '%<run_as>s']
    }
  end

  def build(&block)
    sh(*commands.fetch(:build), &block)
  end

  def run(command = nil, &block)
    cmd = commands.fetch(:run).push(command).compact

    sh(*cmd, &block)
  end

  def exec(command = nil, &block)
    command = Shellwords.split(command || image.exec_command)
    cmd = commands.fetch(:exec).push(*command)

    sh(*cmd, &block)
  end

  def start(&block)
    sh(*commands.fetch(:start), &block) unless started?
  end

  def stop(&block)
    sh(*commands.fetch(:stop), &block) if started?
  end

  def restart(&block)
    stop(&block)
    start(&block)
  end

  # @return [Array<Symbol>]
  def actions
    %i[restart start stop exec run build].sort
  end

  # Denote container is already running/started
  #
  # @return [Boolean]
  def started?
    res = Open3.capture3(*commands.fetch(:started?))[0]

    # res SHOULD be (true|false)
    # but, it can also be an empty string
    true == YAML.safe_load(res)
  end

  protected

  # @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
  def sh(*cmd, &block)
    options = cmd.last.is_a?(Hash) ? cmd.pop : {}
    options[:verbose] = config[:verbose] unless options.key?(:verbose)

    Class.new do
      require 'rake/file_utils'

      include FileUtils
    end.new.sh(*cmd.map(&:to_s).push(options), &block)
  end
end
