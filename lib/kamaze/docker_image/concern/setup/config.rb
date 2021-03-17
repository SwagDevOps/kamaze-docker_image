# frozen_string_literal: true

# Copyright (C) 2017-2021 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../setup'
require 'ostruct'

# Config data structure
#
# @see https://ruby-doc.org/stdlib-2.0.0/libdoc/ostruct/rdoc/OpenStruct.html
class Kamaze::DockerImage::Concern::Setup::Config < OpenStruct
  def respond_to_missing?(method, include_private = false)
    super
  end

  # Introduces some strictness on ``OpenStruct#method_missing``
  #
  # @see https://apidock.com/ruby/OpenStruct/method_missing
  # @return [Object]
  def method_missing(method, *args)
    if method[-1] != '='
      unless self.to_h.include?(method.to_sym)
        message = "undefined method `#{method}' for #{self}"

        raise NoMethodError, message, caller(1)
      end
    end

    super
  end
end
