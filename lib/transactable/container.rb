# frozen_string_literal: true

require "dry/container"
require "marameters"

module Transactable
  # Provides a global container of common objects.
  module Container
    extend Dry::Container::Mixin

    register(:instrument, memoize: true) { Instrument.new }
    register(:marameters) { Marameters }
  end
end
