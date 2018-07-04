# frozen_string_literal: true

require 'kamaze/docker_image/loader'

describe Kamaze::DockerImage::Runner::Command, :runner, :'runner/command' do
  # class methods
  it do
    expect(described_class).to respond_to(:new).with(1).arguments
    expect(described_class).to respond_to(:new).with(2).arguments
    expect(described_class).to respond_to(:new).with(3).arguments
  end
end

describe Kamaze::DockerImage::Runner::Command, :runner, :'runner/command' do
  let(:subject) { described_class.new(['true']) }

  # instance methods
  it do
    expect(subject).to respond_to(:to_a).with(0).arguments
    expect(subject).to respond_to(:to_s).with(0).arguments
    expect(subject).to respond_to(:run).with(0).arguments
  end
end

describe Kamaze::DockerImage::Runner::Command, :runner, :'runner/command' do
  let(:subject) { described_class.new(['true']) }

  context '#to_s' do
    it { expect(subject.to_s).to eq('true') }
  end

  context '#to_a' do
    it { expect(subject.to_a).to eq(['true']) }
  end

  context '#run' do
    it { expect(subject.run).to be(true) }
  end
end

# internal stuff: protected method utils
# utils method provides access to rake ``sh`` method
#
# @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
describe Kamaze::DockerImage::Runner::Command, :runner, :'runner/command' do
  let(:subject) { described_class.new(['true']) }
  let(:utils) { subject.__send__(:utils) }

  context '#utils.class' do
    it { expect(utils.class).to be_a(Class) }
  end

  context '#utils' do
    it { expect(utils).to respond_to(:sh).with_unlimited_arguments }
  end

  context '#utils.sh' do
    it { expect { |b| utils.sh('true', verbose: false, &b) }.to yield_control }
  end
end
