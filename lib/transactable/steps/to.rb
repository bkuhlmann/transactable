# frozen_string_literal: true

module Transactable
  module Steps
    # Delegates to a non-callable operation which automatically wraps the result if necessary.
    class To < Abstract
      prepend Instrumentable

      def initialize operation, message, **dependencies
        super(**dependencies)
        @operation = operation
        @message = message
      end

      def call result
        result.bind do |arguments|
          splat = marameters.categorize operation.method(message).parameters, arguments
          wrap operation.public_send(message, *splat.positionals, **splat.keywords, &splat.block)
        end
      end

      private

      attr_reader :operation, :message

      def wrap(result) = result.is_a?(Dry::Monads::Result) ? result : Success(result)
    end
  end
end
