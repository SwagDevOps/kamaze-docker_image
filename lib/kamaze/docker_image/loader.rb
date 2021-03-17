# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'

# Loader for tasks (using eval binding)
class Kamaze::DockerImage::Loader
  autoload :Pathname, 'pathname'
  autoload :Context, "#{__dir__}/loader/context"

  # @param [Kamaze::DockerImage] image
  def initialize(image)
    @image = image.clone.freeze
  end

  # Load tasks.
  #
  # @return [self]
  def call
    self.tap do
      if loadable?
        context.call do |b|
          b.local_variable_set(:image, image)
          b.eval(content)
        end
      end
    end
  end

  # @return [Boolean]
  def loadable?
    context.dsl?
  end

  protected

  # @return [Kamaze::DockerImage]
  attr_reader :image

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

  # @return [Module<Context>]
  def context
    Context
  end
end
