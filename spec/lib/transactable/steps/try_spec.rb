# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Try do
  include Dry::Monads[:result]

  subject(:step) { described_class.new :inspect, catch: NoMethodError }

  include_context "with instrumentation"

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success with no arguments" do
      result = step.call Success(:test)
      expect(result.success).to eq(":test")
    end

    it "answers success with positional arguments" do
      step = described_class.new :split, ".", catch: NoMethodError
      result = step.call Success("one.two")

      expect(result.success).to eq(%w[one two])
    end

    it "answers success with positional and keyword arguments" do
      step = described_class.new :transform_keys, label: :title, catch: NoMethodError
      result = step.call Success(label: "Test")

      expect(result.success).to eq(title: "Test")
    end

    it "answers failure with invalid message" do
      step = described_class.new :bogus, catch: NoMethodError
      result = step.call Success("test")

      expect(result.failure).to match(/undefined method `bogus'/)
    end

    it "answers failure with invalid arguments" do
      step = described_class.new :split, :bogus, catch: TypeError
      result = step.call Success("test")

      expect(result.failure).to match(/wrong argument type/)
    end

    it "answers exception with wrong exception caught" do
      step = described_class.new :bogus, catch: ArgumentError
      expectation = proc { step.call Success("test") }

      expect(&expectation).to raise_error(NoMethodError, /undefined method/)
    end

    it "passes failures through" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
