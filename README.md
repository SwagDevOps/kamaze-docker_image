<!-- ( vim: set fenc=utf-8 spell spl=en: ) -->

# Easyfier for Docker image projects

This ``gem`` can be used with [``rake``][rake], in order to provide
recurrent tasks related to Docker image development. ATM the following tasks
are provided:

```
rake build                 # Build image
rake exec[command]         # Run a command in a running container
rake restart               # Restart container
rake run[command]          # Run a command in a new container
rake start                 # Start container as sample_image
rake stop                  # Stop container

```

## Sample of use

In your ``Rakefile``:

```ruby
require 'rubygems'
require 'bundler/setup'
require 'kamaze/docker_image'

Kamaze::DockerImage.new do |config|
  config.name    = 'awseome_image'
  config.version = '4.2.2'

  config.path    = 'image'
  config.verbose = false
end

task default: [:build]
```

## Install

In your ``gems.rb``:

```ruby
source 'https://rubygems.org'
git_source(:github) { |name| "https://github.com/#{name}.git" }

gem 'kamaze-docker_image', \
    github: 'SwagDevOps/kamaze-docker_image', branch: 'master'
```

[rake]: https://github.com/ruby/rake
