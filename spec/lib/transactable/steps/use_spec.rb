# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Use do
  include Dry::Monads[:result]

  subject(:step) { described_class.new operation }

  include_context "with instrumentation"

  let(:operation) { -> input { Success input * 2 } }

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success" do
      result = step.call Success(3)
      expect(result.success).to eq(6)
    end

    it "passes failure through" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
