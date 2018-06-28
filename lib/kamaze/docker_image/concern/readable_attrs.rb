# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../concern'

# Provides ``readable_attrs`` method
#
# Readable attributes have an instance variable and an accessor,
# boolean accessors are also supported.
#
# As a result, class including this module obtains a Hash representation.
module Kamaze::DockerImage::Concern::ReadableAttrs
  # Get readable attributes
  #
  # @return [Array<Symbol>]
  def readable_attrs
    instance_variables.clone.map do |attr|
      k = attr.to_s.gsub(/^@/, '').to_sym

      methods = ([k, "#{k}?".to_sym] & public_methods)

      methods.empty? ? nil : k
    end.compact
  end

  # @return [Hash]
  def to_h
    attrs = {}
    readable_attrs.each do |k|
      ([k, "#{k}?".to_sym] & public_methods).each do |m|
        attrs[k] = self.public_send(m)
      end
    end

    attrs
  end
end
