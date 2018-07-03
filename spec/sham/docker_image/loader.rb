# frozen_string_literal: true

require 'kamaze/docker_image/loader'

Sham.config(FactoryStruct, 'docker_image/loader') do |c|
  c.attributes do
    {
      images: {
        base: Kamaze::DockerImage::Loader
          .new(sham!(:docker_image).images.fetch(:base))
      },
      rake_dsl: lambda do
        begin
          Object.const_get('Rake::DSL')
        rescue NameError
          nil
        end
      end.call,
    }
  end
end
