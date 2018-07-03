# frozen_string_literal: true

require 'kamaze/docker_image/runner'

describe Kamaze::DockerImage::Runner, :runner do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
  end
end

describe Kamaze::DockerImage::Runner, :runner do
  let(:subject) { sham!(:runner).maker.call(:base) }

  # instance methods
  it do
    # actions
    expect(subject).to respond_to(:build).with(0).arguments
    expect(subject).to respond_to(:run).with(0).arguments
    expect(subject).to respond_to(:run).with(1).arguments
    expect(subject).to respond_to(:exec).with(0).arguments
    expect(subject).to respond_to(:exec).with(1).arguments
    expect(subject).to respond_to(:start).with(0).arguments
    expect(subject).to respond_to(:run).with(0).arguments
    expect(subject).to respond_to(:stop).with(0).arguments
    expect(subject).to respond_to(:restart).with(0).arguments
    # misc
    expect(subject).to respond_to(:actions).with(0).arguments
    expect(subject).to respond_to(:started?).with(0).arguments
    expect(subject).to respond_to(:running?).with(0).arguments
  end
end
