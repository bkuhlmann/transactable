# frozen_string_literal: true

module Transactable
  module Steps
    # Wraps Dry Monads `#bind` method as a step.
    class Bind < Abstract
      prepend Instrumentable

      def call(result) = result.bind { |input| base_block.call input }
    end
  end
end
