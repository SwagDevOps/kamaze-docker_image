# frozen_string_literal: true

# Copyright (C) 2017-2018 Dimitri Arrigoni <dimitri@arrigoni.me>
# License GPLv3+: GNU GPL version 3 or later
# <http://www.gnu.org/licenses/gpl.html>.
# This is free software: you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.

require_relative '../loader'

# Provides empty binding.
#
# Sample of use:
#
# ```ruby
# Empty.binding.tap do |b|
#   b.local_variable_set(:answer, 42)
#   b.local_variable_set(:home, '127.0.0.1')
#
#   b.eval(content)
# end
# ```
class Kamaze::DockerImage::Loader::Empty
  class << self
    # @return [Binding]
    def binding
      load_dsl

      super.tap do |b|
        b.local_variable_set(:ready, dsl?)
      end
    end

    # @return [Rake::DSL|nil]
    def dsl
      Object.const_get('Rake::DSL')
    rescue NameError
      nil
    end

    # Denote ``DSL`` is defined.
    #
    # @return [Boolean]
    def dsl?
      !!dsl
    end

    protected

    # Apply ``Rake::DSL``
    #
    # @return [self]
    def load_dsl
      self.extend(dsl) if dsl

      self
    end
  end
end
