# frozen_string_literal: true

require 'pathname'
require 'sham'
require_relative 'local'

if Gem::Specification.find_all_by_name('sys-proc').any?
  require 'sys/proc'

  Sys::Proc.progname = 'rspec'
end

Sham::Config.activate!(Pathname.new(__dir__).join('..').realpath)

Object.class_eval { include Local }

RSpec.configure do |rspec|
  # @see https://github.com/rspec/rspec-core/issues/2246
  rspec.around(:example) do |example|
    begin
      example.run
    rescue SystemExit => e
      raise "Unhandled SystemExit (#{e.status})"
    end
  end
end
