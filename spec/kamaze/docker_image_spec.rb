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
    expect(subject).to respond_to(:tag).with(0).arguments
    # attr_reader
    expect(subject).to respond_to(:tasks_ns).with(0).arguments
    expect(subject).to respond_to(:run_as).with(0).arguments
    expect(subject).to respond_to(:version).with(0).arguments
    expect(subject).to respond_to(:name).with(0).arguments
    expect(subject).to respond_to(:commands).with(0).arguments
  end
end

describe Kamaze::DockerImage, :docker_image do
  it do
    # magic methods
    expect(subject).to respond_to(:build).with(0).arguments
    expect(subject).to respond_to(:run).with(0).arguments
    expect(subject).to respond_to(:run).with(1).arguments
    expect(subject).to respond_to(:exec).with(0).arguments
    expect(subject).to respond_to(:exec).with(1).arguments
    expect(subject).to respond_to(:start).with(0).arguments
    expect(subject).to respond_to(:stop).with(0).arguments
    expect(subject).to respond_to(:restart).with(0).arguments
  end
end

describe Kamaze::DockerImage, :docker_image do
  context '#to_h' do
    it { expect(subject.to_h).to be_a(Hash) }
  end

  context '#to_h.keys' do
    it do
      [:commands,
       :docker_bin,
       :exec_command,
       :name,
       :path,
       :run_as,
       :tag,
       :tasks_load,
       :tasks_ns,
       :verbose,
       :version].tap { |keys| expect(subject.to_h.keys).to eq(keys) }
    end
  end
end

describe Kamaze::DockerImage, :docker_image do
  context '#commands' do
    it { expect(subject.commands).to be_a(Hash) }
  end

  context '#commands.keys.sort' do
    it do
      [:build, :exec, :run, :start, :stop]
        .sort
        .tap { |keys| expect(subject.commands.keys.sort).to eq(keys) }
    end
  end
end

# Using an image without version (default is ``latest``)
describe Kamaze::DockerImage, :docker_image do
  let(:subject) { sham!(:image).maker.call(:base) }

  context '#version' do
    it { expect(subject.version).to eq('latest') }
  end

  [:to_s, :tag].each do |method|
    context "##{method}" do
      it { expect(subject.public_send(method)).to eq('sample/base:latest') }
    end
  end
end
