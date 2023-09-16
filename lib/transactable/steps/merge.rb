# frozen_string_literal: true

module Transactable
  module Steps
    # Merges initialized attributes with step argument for use by a subsequent step.
    class Merge < Abstract
      def initialize as: :step, **keywords
        super(**keywords)
        @as = as
      end

      def call result
        result.fmap do |input|
          if input.is_a? Hash
            input.merge! base_keywords
          else
            {as => input}.merge!(base_keywords)
          end
        end
      end

      private

      attr_reader :as
    end
  end
end
