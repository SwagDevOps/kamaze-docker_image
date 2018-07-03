# frozen_string_literal: true

require 'kamaze/docker_image/runner'

describe Kamaze::DockerImage::Runner, :runner do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
  end
end
