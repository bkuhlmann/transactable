# frozen_string_literal: true

require "dry/monads"

module Transactable
  module Steps
    # Provides the blueprint for a step to used in function composition.
    class Abstract
      DEPENDENCIES = %i[instrument marameters].freeze

      include Import[*DEPENDENCIES]
      include Dry::Monads[:result]
      include Composable

      def initialize *positionals, **keywords, &block
        super(**keywords.slice(*DEPENDENCIES))
        @base_positionals = positionals
        @base_keywords = keywords.except(*DEPENDENCIES)
        @base_block = block
      end

      protected

      attr_reader :base_positionals, :base_keywords, :base_block
    end
  end
end
