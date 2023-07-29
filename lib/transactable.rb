# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.for_gem.setup

# Main namespace.
module Transactable
  def self.included(descendant) = descendant.include Pipeable.new

  def self.with(...) = Pipeable.new(...)
end
