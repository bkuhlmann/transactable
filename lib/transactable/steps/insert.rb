# frozen_string_literal: true

module Transactable
  module Steps
    # Inserts elements before, after, or around input.
    class Insert < Abstract
      prepend Instrumentable

      LAST = -1

      def initialize(*positionals, at: LAST, **)
        super(*positionals, **)
        @value = positionals.empty? ? base_keywords : positionals.flatten
        @at = at
      end

      def call result
        result.fmap do |input|
          cast = input.is_a?(Array) ? input : [input]
          value.is_a?(Array) ? cast.insert(at, *value) : cast.insert(at, value)
        end
      end

      private

      attr_reader :value, :at
    end
  end
end
