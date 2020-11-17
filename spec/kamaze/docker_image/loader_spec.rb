# frozen_string_literal: true

require 'kamaze/docker_image/loader'

describe Kamaze::DockerImage::Loader, :loader do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
  end
end

describe Kamaze::DockerImage::Loader, :loader do
  let(:subject) { sham!(:loader).maker.call(:base) }

  # instance methods
  it do
    expect(subject).to respond_to(:loadable?).with(0).arguments
    expect(subject).to respond_to(:call).with(0).arguments
  end
end

describe Kamaze::DockerImage::Loader, :loader do
  let(:subject) { sham!(:loader).maker.call(:base) }
  let(:rake_dsl) { sham!(:rake).dsl }

  context '#loadable?' do
    it { expect(subject.loadable?).to be(!!rake_dsl) }
  end
end

# internal stuff (protected methods)
describe Kamaze::DockerImage::Loader, :loader do
  let(:subject) { sham!(:loader).maker.call(:base) }

  context '#context' do
    it { expect(subject.__send__(:context)).to be_a(Module) }
    it { expect(subject.__send__(:context)).to eq(Kamaze::DockerImage::Loader::Empty) }
  end

  context '#file' do
    it { expect(subject.__send__(:file)).to be_a(Pathname) }
  end

  context '#content' do
    it { expect(subject.__send__(:content)).to be_a(String) }
  end
end
