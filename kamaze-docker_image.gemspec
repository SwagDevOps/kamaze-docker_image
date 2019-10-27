# frozen_string_literal: true
# vim: ai ts=2 sts=2 et sw=2 ft=ruby
# rubocop:disable all

Gem::Specification.new do |s|
  s.name        = "kamaze-docker_image"
  s.version     = "0.0.2"
  s.date        = "2019-10-27"
  s.summary     = "Easyfier for (docker) image projects"
  s.description = "Provide rake tasks to manage image."

  s.licenses    = ["GPL-3.0"]
  s.authors     = ["Dimitri Arrigoni"]
  s.email       = "dimitri@arrigoni.me"
  s.homepage    = "https://github.com/SwagDevOps/kamaze-docker_image"

  # MUST follow the higher required_ruby_version
  # requires version >= 2.3.0 due to safe navigation operator &
  s.required_ruby_version = ">= 2.3.0"
  s.require_paths = ["lib"]
  s.files         = [
    ".rubocop.yml",
    ".yardopts",
    "lib/kamaze-docker_image.rb",
    "lib/kamaze/docker_image.rb",
    "lib/kamaze/docker_image/command.rb",
    "lib/kamaze/docker_image/concern.rb",
    "lib/kamaze/docker_image/concern/docker.rb",
    "lib/kamaze/docker_image/concern/readable_attrs.rb",
    "lib/kamaze/docker_image/concern/setup.rb",
    "lib/kamaze/docker_image/concern/setup/config.rb",
    "lib/kamaze/docker_image/loader.rb",
    "lib/kamaze/docker_image/loader/empty.rb",
    "lib/kamaze/docker_image/loader/helper.rb",
    "lib/kamaze/docker_image/loader/tasks.rb",
    "lib/kamaze/docker_image/loader/tasks/build.rb",
    "lib/kamaze/docker_image/loader/tasks/exec.rb",
    "lib/kamaze/docker_image/loader/tasks/push.rb",
    "lib/kamaze/docker_image/loader/tasks/restart.rb",
    "lib/kamaze/docker_image/loader/tasks/run.rb",
    "lib/kamaze/docker_image/loader/tasks/ssh.rb",
    "lib/kamaze/docker_image/loader/tasks/start.rb",
    "lib/kamaze/docker_image/loader/tasks/stop.rb",
    "lib/kamaze/docker_image/runner.rb",
    "lib/kamaze/docker_image/runner/storage.rb",
    "lib/kamaze/docker_image/ssh.rb",
    "lib/kamaze/docker_image/version.rb",
    "lib/kamaze/docker_image/version.yml",
  ]

  s.add_runtime_dependency("cliver", ["~> 0.3"])
  s.add_runtime_dependency("docker-api", ["~> 1.34"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
end

# Local Variables:
# mode: ruby
# End:
