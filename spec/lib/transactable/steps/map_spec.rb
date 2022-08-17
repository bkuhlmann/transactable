# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Map do
  include Dry::Monads[:result]

  subject(:step) { described_class.new(&:to_s) }

  include_context "with instrumentation"

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success" do
      result = step.call Success(%i[a b c])
      expect(result.success).to eq(%w[a b c])
    end

    it "passes failures through" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
