# frozen_string_literal: true

module Transactable
  module Steps
    # Allows result to be messaged as a callable.
    class As < Abstract
      def call result
        result.fmap { |operation| operation.public_send(*base_positionals, **base_keywords) }
      end
    end
  end
end
