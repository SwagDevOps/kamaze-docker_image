# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../runner'

class Kamaze::DockerImage::Runner::Command < Array
  def run(&block)
    sh(*self, &block)
  end

  protected

  # @see https://github.com/ruby/rake/blob/124a03bf4c0db41cd80a41394a9e7c6426e44784/lib/rake/file_utils.rb#L43
  def sh(*cmd, &block)
    options = cmd.last.is_a?(Hash) ? cmd.pop : {}
    options[:verbose] = config[:verbose] unless options.key?(:verbose)

    Class.new do
      require 'rake'
      require 'rake/file_utils'

      include FileUtils
    end.new.sh(*cmd.map(&:to_s).push(options), &block)
  end
end
