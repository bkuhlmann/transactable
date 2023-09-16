# frozen_string_literal: true

require "dry/monads"

module Transactable
  # Provids low-level functionality that can process a sequence of steps.
  Pipe = lambda do |input, *steps|
    fail ArgumentError, "Pipe must have at least one step." if steps.empty?

    result = input.is_a?(Dry::Monads::Result) ? input : Dry::Monads::Success(input)

    steps.reduce(&:>>).call result
  rescue NoMethodError
    raise TypeError, "Step must be functionally composable and answer a monad."
  end
end
