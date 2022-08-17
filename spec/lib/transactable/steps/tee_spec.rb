# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Tee do
  include Dry::Monads[:result]

  subject(:step) { described_class.new operation, :call }

  include_context "with instrumentation"

  let(:operation) { instance_spy Proc }

  describe "#call" do
    it_behaves_like "an instrument"

    context "with success" do
      let(:result) { Success "test" }

      it "calls operation with no arguments" do
        step.call result
        expect(operation).to have_received(:call)
      end

      it "calls operation with positional and keyword arguments" do
        step = described_class.new operation, :call, "one", two: 2
        step.call result

        expect(operation).to have_received(:call).with("one", two: 2)
      end

      it "answers success" do
        expect(step.call(result)).to eq(result)
      end
    end

    context "with failure" do
      let(:result) { Failure "Danger!" }

      it "call operation" do
        step.call result
        expect(operation).to have_received(:call)
      end

      it "answers failure" do
        expect(step.call(result)).to eq(result)
      end
    end
  end
end
