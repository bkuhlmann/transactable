# frozen_string_literal: true

require "dry/container"

module Transactable
  module Steps
    # Registers all default steps.
    module Container
      extend Dry::Container::Mixin

      register(:as) { As }
      register(:bind) { Bind }
      register(:check) { Check }
      register(:fmap) { Fmap }
      register(:insert) { Insert }
      register(:map) { Map }
      register(:merge) { Merge }
      register(:orr) { Or }
      register(:tee) { Tee }
      register(:to) { To }
      register(:try) { Try }
      register(:use) { Use }
      register(:validate) { Validate }
    end
  end
end
