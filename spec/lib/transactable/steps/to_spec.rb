# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::To do
  include Dry::Monads[:result]

  subject(:step) { described_class.new operation.new, :for }

  include_context "with instrumentation"

  let :operation do
    Class.new Transactable::Steps::Abstract do
      def for(first, last: 2) = Dry::Monads::Success base_positionals.append(first, last)
    end
  end

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success with monadic operation" do
      result = step.call Success([1, {last: 3}])
      expect(result.success).to eq([1, 3])
    end

    context "with non-monadic operation" do
      subject(:step) { described_class.new operation.new, :for }

      it "answers success" do
        result = step.call Success([1, {last: 3}])
        expect(result.success).to eq([1, 3])
      end
    end

    context "with non-monadic response" do
      let :operation do
        Class.new Transactable::Steps::Abstract do
          def for(first, last: 2) = base_positionals.append(first, last)
        end
      end

      it "answers success" do
        result = step.call Success([1, {last: 3}])
        expect(result.success).to eq([1, 3])
      end
    end

    context "with keywords" do
      subject(:step) { described_class.new operation, :for }

      let :operation do
        Struct.new :label, keyword_init: true do
          include Dry::Monads[:result]

          def self.for(...) = Dry::Monads::Success new(...)
        end
      end

      it "answers success" do
        result = step.call Success(label: :test)
        expect(result.success).to eq(operation[label: :test])
      end
    end

    it "passes failures through" do
      result = step.call Failure("Danger!")
      expect(result.failure).to eq("Danger!")
    end
  end
end
