# frozen_string_literal: true

require 'kamaze/docker_image/loader'

describe Kamaze::DockerImage::Loader::Context, :loader, :'loader/context' do
  # class methods
  it do
    expect(described_class).to respond_to(:call).with(0).arguments
    expect(described_class).to respond_to(:dsl?).with(0).arguments
  end
end
