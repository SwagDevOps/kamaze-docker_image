# frozen_string_literal: true

require 'kamaze/docker_image'

Sham.config(FactoryStruct, :docker_image) do |c|
  c.attributes do
    {
      images: {
        base: Kamaze::DockerImage.new do |config|
          config.name = 'sample/base'
          config.tasks_load = false
        end
      }
    }
  end
end
