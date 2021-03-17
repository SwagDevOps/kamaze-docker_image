# frozen_string_literal: true

require 'bundler/setup'
require_relative 'lib/kamaze-docker_image'
require 'kamaze/docker_image'
require 'kamaze/project'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze.project do |project|
  project.subject = Kamaze::DockerImage
  project.name    = 'kamaze-docker_image'
  project.tasks   = [
    'cs:correct', 'cs:control', 'cs:pre-commit',
    'doc', 'doc:watch',
    'gem', 'gem:install', 'gem:push',
    'misc:gitignore',
    'shell', 'sources:license', 'test', 'version:edit',
  ]
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end

Kamaze::DockerImage.new do |config|
  config.name     = 'kamaze/sample_image'
  config.version  = '0.0.1'

  config.path     = 'image'
  config.run_as   = config.name.tr('/', '_')
  config.tasks_ns = 'docker'
  config.ssh      = {
    enabled: true,
  }
end.tap do |image|
  self.singleton_class.__send__(:define_method, :image) do
    image
  end
end
