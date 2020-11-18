# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../docker_image'

# rubocop:disable Style/Documentation

module Kamaze::DockerImage::Concern
  {
    Setup: 'setup',
    Docker: 'docker',
    Executable: 'executable',
    ReadableAttrs: 'readable_attrs',
  }.each { |k, v| autoload(k, "#{__dir__}/concern/#{v}") }
end

# rubocop:enable Style/Documentation
