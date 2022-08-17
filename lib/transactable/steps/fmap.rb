# frozen_string_literal: true

module Transactable
  module Steps
    # Wraps Dry Monads `#fmap` method as a step.
    class Fmap < Abstract
      prepend Instrumentable

      def call(result) = result.fmap { |input| base_block.call input }
    end
  end
end
