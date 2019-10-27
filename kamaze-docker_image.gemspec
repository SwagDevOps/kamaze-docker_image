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
  s.files = [
    ".yardopts",
    "lib/**/*.rb",
    "lib/**/*.yml",
  ].map { |m| Dir.glob(m) }.flatten.sort

  s.add_runtime_dependency("cliver", ["~> 0.3"])
  s.add_runtime_dependency("docker-api", ["~> 1.34"])
  s.add_runtime_dependency("kamaze-version", ["~> 1.0"])
end

# Local Variables:
# mode: ruby
# End:
