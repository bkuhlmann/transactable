# frozen_string_literal: true

module Transactable
  module Steps
    # Wraps Dry Monads `#or` method as a step.
    class Or < Abstract
      def call(result) = result.or { |input| base_block.call input }
    end
  end
end
