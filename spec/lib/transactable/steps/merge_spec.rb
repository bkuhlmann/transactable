# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Merge do
  include Dry::Monads[:result]

  subject(:step) { described_class.new a: 1 }

  include_context "with instrumentation"

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success with both attributes merged" do
      expect(step.call(Success(b: 2))).to eq(Success(a: 1, b: 2))
    end

    it "answers success with input merged with attributes using default key" do
      expect(step.call(Success("test"))).to eq(Success(a: 1, step: "test"))
    end

    it "answers success with input merged with attributes using custom key" do
      step = described_class.new a: 1, as: :text
      expect(step.call(Success("test"))).to eq(Success(a: 1, text: "test"))
    end

    it "passes failures through" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
