# frozen_string_literal: true

module Transactable
  module Steps
    # Checks if operation is true and then answers success (passthrough) or failure (with argument).
    class Check < Abstract
      prepend Instrumentable

      def initialize(operation, message, **)
        super(**)
        @operation = operation
        @message = message
      end

      def call result
        result.bind do |arguments|
          answer = question arguments
          answer == true || answer.is_a?(Success) ? result : Failure(arguments)
        end
      end

      private

      attr_reader :operation, :message

      def question arguments
        splat = marameters.categorize operation.method(message).parameters, arguments
        operation.public_send(message, *splat.positionals, **splat.keywords, &splat.block)
      end
    end
  end
end
