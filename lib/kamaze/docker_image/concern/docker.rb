# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides setup (used during initialization) and related methods.
#
# @todo remove this file, it SHOULD be useless
module Kamaze::DockerImage::Concern::Docker
  autoload(:Docker, 'docker')

  protected

  # Fetch containers
  #
  # @param [String] run_as
  # @param [Array|nil] states
  # @return [Array<Docker::Container>]
  def fetch_containers(run_as, states = nil)
    unless states.nil?
      states = (states.is_a?(Array) ? states : [states]).map(&:to_s)
      states = nil if states.empty?
    end

    Docker::Container.all(all: true).keep_if do |c|
      states.to_a.empty? ? true : states.include?(c.info.fetch('State'))
    end.keep_if do |c|
      c.info.fetch('Names').include?("/#{run_as}")
    end
  end
end
