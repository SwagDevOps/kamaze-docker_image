# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'

# Loader for tasks (using eval binding)
class Kamaze::DockerImage::Loader
  autoload :Pathname, 'pathname'
  autoload :Empty, "#{__dir__}/loader/empty"

  # @param [Kamaze::DockerImage] image
  def initialize(image)
    @image = image.clone.freeze
  end

  # Load tasks.
  #
  # @return [self]
  def call
    if loadable?
      empty_binding.tap do |b|
        b.local_variable_set(:image, image)
        b.eval(content)
      end
    end

    self
  end

  # @return [Boolean]
  def loadable?
    empty_binding.local_variable_get(:ready)
  end

  protected

  # @return [Kamaze::DockerImage]
  attr_reader :image

  # Get en empty binding.
  #
  # @return [Empty]
  def empty_binding
    Empty.binding
  end

  # @return [Pathname]
  def file
    Pathname.new(__dir__).join('loader', 'tasks.rb')
  end

  # Tasks file content (to eval)
  #
  # @return [String]
  def content
    file.read
  end
end
