# frozen_string_literal: true

require 'kamaze/docker_image'

Sham.config(FactoryStruct, :image) do |c|
  c.attributes do
    {
      maker: lambda do |type|
        attrs = {
          base: {
            name: 'sample/base'
          }
        }.fetch(type.to_sym)

        Kamaze::DockerImage.new do |config|
          attrs.each do |k, v|
            config.public_send("#{k}=", v)
          end

          config.tasks_load = false
        end
      end
    }
  end
end
