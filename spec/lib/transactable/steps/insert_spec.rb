# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Steps::Insert do
  include Dry::Monads[:result]

  subject(:step) { described_class.new :z }

  include_context "with instrumentation"

  describe "#call" do
    it_behaves_like "an instrument"

    it "answers success with single element prepended to single input" do
      step = described_class.new :z, at: 0
      expect(step.call(Success(:a)).success).to eq(%i[z a])
    end

    it "answers success with single element prepended to input array" do
      step = described_class.new :z, at: 0
      expect(step.call(Success(%i[a b])).success).to eq(%i[z a b])
    end

    it "answers success with array prepended to single input" do
      step = described_class.new %i[y z], at: 0
      expect(step.call(Success(:a)).success).to eq(%i[y z a])
    end

    it "answers success with single element inserted within input array" do
      step = described_class.new :z, at: 2
      expect(step.call(Success(%i[a b c])).success).to eq(%i[a b z c])
    end

    it "answers success with array inserted within input array" do
      step = described_class.new %i[y z], at: 2
      expect(step.call(Success(%i[a b c])).success).to eq(%i[a b y z c])
    end

    it "answers success with single element appended to single input" do
      expect(step.call(Success(:a)).success).to eq(%i[a z])
    end

    it "answers success with single element appended to input array" do
      expect(step.call(Success(%i[a b])).success).to eq(%i[a b z])
    end

    it "answers success with array appended to single input" do
      step = described_class.new %i[y z]
      expect(step.call(Success(:a)).success).to eq(%i[a y z])
    end

    it "answers success with hash inserted" do
      step = described_class.new b: 2
      expect(step.call(Success(:a)).success).to eq([:a, {b: 2}])
    end

    it "answers success with any object inserted" do
      object = Object.new
      step = described_class.new object

      expect(step.call(Success(:a)).success).to eq([:a, object])
    end
  end
end
