# frozen_string_literal: true

# bundle install --path vendor/bundle
source 'https://rubygems.org'

group :default do
  gem 'cliver', '~> 0.3'
  gem 'docker-api', '~> 1.34'
  gem 'kamaze-version', '~> 1.0'
end

group :development do
  gem 'kamaze-project', '~> 1.0', '>= 1.0.3'
  gem 'listen', '~> 3.1'
  gem 'rubocop', '~> 0.56'
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
