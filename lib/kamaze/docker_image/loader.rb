# frozen_string_literal: true

require_relative '../docker_image'
#require 'rake/dsl_definition'

# Loader for tasks
class Kamaze::DockerImage::Loader
  attr_reader :image

  # @param [Image] image
  def initialize(image)
    @image = image
  end

  # @return [self]
  def call
    self.extend(Rake::DSL)

    eval(IO.read("#{__dir__}/tasks.rb"), binding)

    self
  end
end
