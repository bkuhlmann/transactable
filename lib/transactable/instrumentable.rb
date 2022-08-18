# frozen_string_literal: true

require "dry/monads"

module Transactable
  # Allows a callable to have instrumentation. This module is meant to be prepended only.
  module Instrumentable
    def call(...)
      arguments = [base_positionals, base_keywords, base_block]

      instrument.publish("step", name: self.class.name, arguments:)

      super.fmap { |value| publish_success value, arguments }
           .or { |value| publish_failure value, arguments }
    end

    module_function

    def publish_success value, arguments
      instrument.publish("step.success", name: self.class.name, value:, arguments:)
      value
    end

    def publish_failure value, arguments
      instrument.publish("step.failure", name: self.class.name, value:, arguments:)
      Failure value
    end
  end
end
