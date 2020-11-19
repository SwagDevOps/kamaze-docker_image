# frozen_string_literal: true

# ```sh
# bundle config set clean 'true'
# bundle config set path 'vendor/bundle'
# bundle install
# ```
source 'https://rubygems.org'

group :default do
  gem 'cliver', '~> 0.3'
  gem 'kamaze-version', '~> 1.0'
end

group :development do
  { github: 'SwagDevOps/kamaze-project', branch: 'develop' }.tap do |options|
    gem(*['kamaze-project'].concat([options]))
  end

  gem 'listen', '~> 3.1'
  gem 'rake', '~> 12.3'
  gem 'rubocop', '~> 0.56'
  gem 'rugged', '~> 1.0'
  gem 'sys-proc', '~> 1.1'
end

group :test do
  gem 'rspec', '~> 3.6'
  gem 'sham', '~> 2.0'
end

group :doc do
  gem 'github-markup', '~> 3.0'
  gem 'redcarpet', '~> 3.4'
  gem 'yard', '~> 0.9'
end

group :repl do
  gem 'interesting_methods', '~> 0.1'
  gem 'pry', '~> 0.11'
  gem 'pry-coolline', '~> 0.2'
end
