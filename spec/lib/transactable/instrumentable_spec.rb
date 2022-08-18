# frozen_string_literal: true

require "spec_helper"
require "dry/monads"

RSpec.describe Transactable::Instrumentable do
  include Dry::Monads[:result]

  subject(:instrumentable) { implementation.new :a, b: 2 }

  include_context "with instrumentation"

  let :implementation do
    Class.new Transactable::Steps::Abstract do
      prepend Transactable::Instrumentable

      def self.name = "Test"

      def call(result) = result.fmap { |value| "#{value}-#{base_positionals.first}" }
    end
  end

  describe "#call" do
    it "publishes step with all arguments" do
      function = proc { "test" }
      instrumentable = implementation.new :a, b: 2, &function
      instrumentable.call Success("test")

      expect(event_inspector.step).to have_attributes(
        id: "step",
        payload: {
          name: "Test",
          arguments: [[:a], {b: 2}, function]
        }
      )
    end

    it "publishes step with partial arguments" do
      instrumentable.call Success("test")

      expect(event_inspector.step).to have_attributes(
        id: "step",
        payload: {
          name: "Test",
          arguments: [[:a], {b: 2}, nil]
        }
      )
    end

    it "publishes step with no arguments" do
      implementation.new.call Success("test")

      expect(event_inspector.step).to have_attributes(
        id: "step",
        payload: {
          name: "Test",
          arguments: [[], {}, nil]
        }
      )
    end

    it "publishes success" do
      instrumentable.call Success("test")

      expect(event_inspector.success).to have_attributes(
        id: "step.success",
        payload: {
          name: "Test",
          value: "test-a",
          arguments: [[:a], {b: 2}, nil]
        }
      )
    end

    it "publishes failure" do
      instrumentable.call Failure("test")

      expect(event_inspector.failure).to have_attributes(
        id: "step.failure",
        payload: {
          name: "Test",
          value: "test",
          arguments: [[:a], {b: 2}, nil]
        }
      )
    end
  end
end
