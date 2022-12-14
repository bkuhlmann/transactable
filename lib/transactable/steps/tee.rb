# frozen_string_literal: true

module Transactable
  module Steps
    # Messages operation, without any response checks, while passing input through as output.
    class Tee < Abstract
      prepend Instrumentable

      def initialize operation, *positionals, **dependencies
        super(*positionals, **dependencies)
        @operation = operation
      end

      def call result
        operation.public_send(*base_positionals, **base_keywords)
        result
      end

      private

      attr_reader :operation
    end
  end
end
