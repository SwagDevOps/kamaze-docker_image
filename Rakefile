# frozen_string_literal: true

require_relative 'lib/kamaze-docker_image'
require 'kamaze/docker_image'
require 'sys/proc'

Sys::Proc.progname = nil

Kamaze.project do |project|
  project.subject = Kamaze::DockerImage
  project.name    = 'kamaze-docker_image'
  project.tasks   = [
    'cs:correct', 'cs:control', 'cs:pre-commit',
    'doc', 'doc:watch', 'gem', 'misc:gitignore',
    'shell', 'sources:license', 'test', 'version:edit',
  ]
end.load!

task default: [:gem]

if project.path('spec').directory?
  task :spec do |task, args|
    Rake::Task[:test].invoke(*args.to_a)
  end
end

Kamaze::DockerImage.new do |image|
  image.name     = 'kamaze/sample_image'
  image.version  = '0.0.1'
  image.path     = "#{Dir.pwd}/image"
  image.run_as   = image.name.tr('/', '_')
  image.tasks_ns = 'docker'
end
