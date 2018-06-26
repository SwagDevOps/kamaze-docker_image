# frozen_string_literal: true

# rubocop:disable Style/Documentation

module Kamaze
end

# rubocop:enable Style/Documentation

# Describe a docker image
class Kamaze::DockerImage
  attr_reader :commands
  attr_reader :name
  attr_reader :version
  attr_reader :tasks_ns
  attr_reader :run_as
  attr_reader :exec_command

  autoload :Pathname, 'pathname'
  autoload :OpenStruct, 'ostruct'
  autoload :Runner, "#{__dir__}/docker_image/runner"
  autoload :Loader, "#{__dir__}/docker_image/loader"
  autoload :VERSION, "#{__dir__}/docker_image/version"

  # @param [String] name
  def initialize
    init(caller_locations)

    if block_given?
      os = OpenStruct.new
      yield(os)
      os.to_h.each { |k, v| __send__("#{k}=", v) }
    end

    tasks_load! if tasks_load?
  end

  def public_attrs
    attrs = {}
    instance_variables.each do |ivar|
      k = ivar.to_s.gsub(/^@/, '').to_sym
      next unless self.respond_to?(k)

      attrs[k] = instance_variable_get(ivar)
    end

    attrs
  end

  alias to_h public_attrs

  def to_s
    "#{name}:#{version}".gsub(/:$/, '')
  end

  # @return [Boolean]
  def verbose?
    !!@verbose
  end

  # @return [Boolean]
  def tasks_load?
    !!@tasks_load
  end

  # @return [Pathname]
  def path
    Pathname.new(@path).to_s
  end

  def method_missing(method, *args, &block)
    if respond_to_missing?(method)
      return runner.public_send(method, *args, &block)
    end

    super
  end

  def respond_to_missing?(method, include_private = false)
    return true if runner.respond_to?(method, include_private)

    super(method, include_private)
  end

  protected

  attr_writer :name

  attr_writer :path

  attr_writer :verbose

  attr_writer :version

  attr_writer :tasks_ns

  attr_writer :tasks_load

  attr_writer :run_as

  attr_writer :exec_command

  attr_writer :commands

  def init(locations)
    @name = nil
    @verbose = $stdout.tty? && $stderr.tty?
    @tasks_load = true
    @tasks_ns = nil
    @run_as = called_from(locations).dirname.basename.to_s
    @exec_command = 'bash'
    @commands = default_commands
  end

  # Load tasks
  def tasks_load!
    Loader.new(self).call

    self
  end

  # @return [Runner]
  def runner
    Runner.new(self, commands)
  end

  # @return [Pathname]
  def called_from(locations = caller_locations)
    location = locations.first.path

    Pathname.new(location).realpath
  end

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
