# frozen_string_literal: true

require_relative '../docker_image'

# Loader for tasks (using eval binding)
class Kamaze::DockerImage::Loader
  # Provide access to image (within tasks)
  #
  # @return Kamaze::DockerImage
  attr_reader :image

  # @param [Kamaze::DockerImage] image
  def initialize(image)
    @image = image.clone.freeze
  end

  # @return [self]
  def call
    # rubocop:disable Security/Eval
    eval(content, binding)
    # rubocop:enable Security/Eval

    self
  end

  protected

  # @return [String]
  def content
    IO.read("#{__dir__}/tasks.rb")
  end
end
