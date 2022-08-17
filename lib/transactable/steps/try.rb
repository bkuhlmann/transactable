# frozen_string_literal: true

module Transactable
  module Steps
    # Messages a risky operation which may pass or fail.
    class Try < Abstract
      prepend Instrumentable

      def initialize *positionals, catch:, **keywords
        super(*positionals, **keywords)
        @catch = catch
      end

      def call result
        result.fmap { |operation| operation.public_send(*base_positionals, **base_keywords) }
      rescue *Array(catch) => error
        Failure error.message
      end

      private

      attr_reader :catch
    end
  end
end
