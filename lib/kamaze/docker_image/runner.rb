# frozen_string_literal: true

require_relative '../docker_image'

# Runner
class Kamaze::DockerImage::Runner
  autoload :Cliver, 'cliver'
  autoload :YAML, 'yaml'
  autoload :Open3, 'open3'
  autoload :Shellwords, 'shellwords'

  # @return [Kamaze::DockerImage]
  attr_reader :image

  # @return [Hash]
  attr_reader :commands

  # @param [Kamaze::DockerImage] image
  # @param [Hash] commands
  def initialize(image, commands)
    inspect_started = ['inspect', '-f', '{{.State.Running}}', '%<run_as>s']

    @image = image
    @commands = commands.merge('started?': inspect_started)
  end

  def tty?
    $stdout.tty? and $stderr.tty?
  end

  def build(&block)
    sh(*self.command(:build), &block)
  end

  def run(command = nil, &block)
    cmd = image.command(:run).push(command).compact

    sh(*cmd, &block)
  end

  def exec(command = nil, &block)
    command = Shellwords.split(command || image.exec_command)
    cmd = self.command(:exec).push(*command)

    sh(*cmd, &block)
  end

  def start(&block)
    sh(*self.command(:start), &block) unless started?
  end

  def stop(&block)
    sh(*self.command(:stop), &block) if started?
  end

  def restart(&block)
    stop(&block)
    start(&block)
  end

  def started?
    cmd = image.command(:started?)
    res = Open3.capture3(*cmd)[0]

    # res SHOULD be (true|false)
    # but, it can also be an empty string
    true == YAML.safe_load(res)
  end

  protected

  # Get command for given keyword
  #
  # @param [String|Symbol] keyword
  # @return [Array]
  def command(keyword)
    h = {
      opt_t: tty? ? '-t' : nil,
      opt_it: tty? ? '-it' : nil,
    }

    [executable]
      .push(*commands.fetch(keyword.to_sym))
      .map { |w| w % image.to_h.merge(h) }
      .map { |w| w.to_s.empty? ? nil : w }
      .compact
  end

  # @return [String]
  def executable
    Cliver.detect!('docker')
  end

  # @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
  def sh(*cmd, &block)
    options = cmd.last.is_a?(Hash) ? cmd.pop : {}
    options[:verbose] = image.verbose? unless options.key?(:verbose)

    Class.new do
      require 'rake/file_utils'

      include FileUtils
    end.new.sh(*cmd.map(&:to_s).push(options), &block)
  end
end
