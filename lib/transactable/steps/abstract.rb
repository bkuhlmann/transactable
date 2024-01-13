# frozen_string_literal: true

require "dry/monads"

module Transactable
  module Steps
    # Provides the blueprint for a step to used in function composition.
    class Abstract
      include Import[:instrument, :marameters]
      include Dry::Monads[:result]
      include Composable

      def self.inherited descendant
        super
        descendant.prepend Instrumentable
      end

      def initialize *positionals, **keywords, &block
        super(**keywords.slice(:instrument, :marameters))
        @base_positionals = positionals
        @base_keywords = keywords.except(*infused_keys)
        @base_block = block
      end

      protected

      attr_reader :base_positionals, :base_keywords, :base_block
    end
  end
end
