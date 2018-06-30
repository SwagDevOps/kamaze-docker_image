# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

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

  # @return [Boolean]
  def call
    begin
      self.extend(Rake::DSL)
    rescue StandardError
      return false
    end

    # rubocop:disable Security/Eval
    eval(content, binding)
    # rubocop:enable Security/Eval

    true
  end

  protected

  # Tasks file content (to eval)
  #
  # @return [String]
  def content
    IO.read("#{__dir__}/tasks.rb")
  end
end
