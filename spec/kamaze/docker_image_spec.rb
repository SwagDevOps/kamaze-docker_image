# frozen_string_literal: true

require 'kamaze/docker_image'

describe Kamaze::DockerImage, :docker_image do
  # instance methods
  it do
    expect(subject).to respond_to(:to_h).with(0).arguments
    expect(subject).to respond_to(:started?).with(0).arguments
    expect(subject).to respond_to(:verbose?).with(0).arguments
    expect(subject).to respond_to(:tasks_load?).with(0).arguments
    expect(subject).to respond_to(:path).with(0).arguments
    # attr_reader
    expect(subject).to respond_to(:tasks_ns).with(0).arguments
    expect(subject).to respond_to(:run_as).with(0).arguments
    expect(subject).to respond_to(:version).with(0).arguments
    expect(subject).to respond_to(:name).with(0).arguments
    expect(subject).to respond_to(:commands).with(0).arguments
  end
end

describe Kamaze::DockerImage, :docker_image do
  context '#to_h' do
    it { expect(subject.to_h).to be_a(Hash) }
  end

  context '#to_h.keys' do
    it do
      [:commands,
       :exec_command,
       :name,
       :run_as,
       :tasks_load,
       :tasks_ns,
       :verbose,
       :version].tap { |keys| expect(subject.to_h.keys).to eq(keys) }
    end
  end
end
