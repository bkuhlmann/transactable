# frozen_string_literal: true

require "zeitwerk"

Zeitwerk::Loader.new.then do |loader|
  loader.tag = File.basename __FILE__, ".rb"
  loader.push_dir __dir__
  loader.setup
end

# Main namespace.
module Transactable
  def self.included(descendant) = descendant.include Pipeable.new

  def self.loader(registry = Zeitwerk::Registry) = registry.loader_for __FILE__

  def self.with(...) = Pipeable.new(...)
end
