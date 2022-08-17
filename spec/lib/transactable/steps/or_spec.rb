# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Or do
  include Dry::Monads[:result]

  subject(:step) { described_class.new { |value| Failure "Fail: #{value.inspect}." } }

  include_context "with instrumentation"

  describe "#call" do
    it_behaves_like "an instrument"

    it "passes success through" do
      result = step.call Success(:test)
      expect(result.success).to eq(:test)
    end

    it "answers modified failure" do
      result = step.call Failure(:test)
      expect(result.failure).to eq("Fail: :test.")
    end
  end
end
