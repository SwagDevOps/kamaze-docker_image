# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# PProvide method to retrieve path to docker executable.
module Kamaze::DockerImage::Concern::Executable
  autoload(:Cliver, 'cliver')

  protected

  # Get executable
  #
  # @raise [Cliver::Dependency::NotFound]
  # @return [String]
  def executable
    Cliver.detect!(:docker).freeze
  end
end
