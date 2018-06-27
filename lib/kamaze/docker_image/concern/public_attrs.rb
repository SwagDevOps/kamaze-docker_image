# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides ``public_attrs`` method
module Kamaze::DockerImage::Concern::PublicAttrs
  # Get public attributes
  #
  # @return [Array<Symbol>]
  def public_attrs
    instance_variables.clone.map do |attr|
      k = attr.to_s.gsub(/^@/, '').to_sym

      public_methods.include?(k) ? k : nil
    end.compact
  end
end
