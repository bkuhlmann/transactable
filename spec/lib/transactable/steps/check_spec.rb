# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Check do
  include Dry::Monads[:result]

  subject(:step) { described_class.new operation, :include? }

  include_context "with instrumentation"

  let(:operation) { %i[a b c] }

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success when true" do
      result = Success :a
      expect(step.call(result)).to eq(Success(:a))
    end

    it "answers success when a success" do
      allow(operation).to receive(:include?).and_return(Success("Included."))
      result = Success :a

      expect(step.call(result)).to eq(Success(:a))
    end

    it "answers failure when false" do
      result = Success :x
      expect(step.call(result)).to eq(Failure(:x))
    end
  end
end
