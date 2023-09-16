# frozen_string_literal: true

module Transactable
  module Steps
    # Validates a result via a callable operation.
    class Validate < Abstract
      def initialize(operation, as: :to_h, **)
        super(**)
        @operation = operation
        @as = as
      end

      def call result
        result.bind do |payload|
          value = operation.call payload

          return Failure value if value.failure?

          Success(as ? value.public_send(as) : value)
        end
      end

      private

      attr_reader :operation, :as
    end
  end
end
