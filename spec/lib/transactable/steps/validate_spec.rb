# frozen_string_literal: true

require "spec_helper"
require "dry/schema"

RSpec.describe Transactable::Steps::Validate do
  include Dry::Monads[:result]

  subject(:step) { described_class.new operation }

  include_context "with instrumentation"

  let(:operation) { Dry::Schema.Params { required(:label).filled :string } }

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success with valid payload" do
      result = step.call Success(label: "Test")
      expect(result.success).to eq(label: "Test")
    end

    it "answers success with valid payload and no conversion" do
      step = described_class.new operation, as: nil
      result = step.call Success(label: "Test")

      expect(result.success.to_h).to eq(label: "Test")
    end

    it "answers success with valid payload as specific type" do
      step = described_class.new operation, as: :inspect
      result = step.call Success(label: "Test")

      expect(result.success).to eq(%(#<Dry::Schema::Result{:label=>"Test"} errors={} path=[]>))
    end

    it "answers failure with invalid payload" do
      result = step.call Success(bogus: "invalid")
      expect(result.failure.errors.to_h).to eq(label: ["is missing"])
    end

    it "answers failure with passthrough failure" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
