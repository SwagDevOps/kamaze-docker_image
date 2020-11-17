# frozen_string_literal: true

# Copyright (C) 2017-2020 Dimitri Arrigoni <dimitri@arrigoni.me>
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
# Context.call do |b|
#   b.local_variable_set(:answer, 42)
#   b.local_variable_set(:home, '127.0.0.1')
#
#   b.eval(content)
# end
# ```
module Kamaze::DockerImage::Loader::Context
  class << self
    def call
      yield(binding)
    end

    # Denote ``DSL`` is defined.
    #
    # @return [Boolean]
    def dsl?
      !!dsl
    end

    protected

    # @return [Binding]
    def binding
      -> { super }.tap { load_dsl }.call
    end

    # @return [Rake::DSL, nil]
    def dsl
      Object.const_get('Rake::DSL')
    rescue NameError
      nil
    end

    # Apply ``Rake::DSL``
    #
    # @return [self]
    def load_dsl
      self.tap { self.extend(dsl) if dsl? }
    end
  end
end
