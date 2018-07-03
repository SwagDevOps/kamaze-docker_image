# frozen_string_literal: true

require 'kamaze/docker_image/runner'

Sham.config(FactoryStruct, :runner) do |c|
  c.attributes do
    {
      maker: lambda do |type|
        image = sham!(:image).maker.call(type.to_sym)

        Kamaze::DockerImage::Runner.new(image)
      end
    }
  end
end
