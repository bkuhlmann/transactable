# frozen_string_literal: true

module Transactable
  module Steps
    # Maps over a collection, processing each element, and answering a new result.
    class Map < Abstract
      def call(result) = result.fmap { |collection| collection.map(&base_block) }
    end
  end
end
