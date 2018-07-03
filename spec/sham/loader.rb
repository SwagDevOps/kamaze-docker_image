# frozen_string_literal: true

require 'kamaze/docker_image/loader'

Sham.config(FactoryStruct, :loader) do |c|
  c.attributes do
    {
      maker: lambda do |type|
        image = sham!(:image).maker.call(type.to_sym)

        Kamaze::DockerImage::Loader.new(image)
      end
    }
  end
end
