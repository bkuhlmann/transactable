# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Composable do
  subject(:composable) { implementation.new }

  let :implementation do
    Class.new do
      include Transactable::Composable

      def call(value) = value + default

      def initialize default = 5
        @default = default
      end

      private

      attr_reader :default
    end
  end

  let(:multiplier) { -> value { value * 2 } }

  describe "#>>" do
    it "answers computed value" do
      result = (multiplier >> composable).call 3
      expect(result).to eq(11)
    end
  end

  describe "#<<" do
    it "answers computed value" do
      result = (multiplier << composable).call 3
      expect(result).to eq(16)
    end
  end

  describe "#call" do
    it "answers computed value" do
      expect(composable.call(10)).to eq(15)
    end

    it "fails when not implemented" do
      expectation = proc { Class.new.include(described_class).new.call }
      expect(&expectation).to raise_error(NotImplementedError, "`#call` must be implemented.")
    end
  end
end
