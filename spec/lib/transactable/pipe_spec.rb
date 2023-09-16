# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Transactable::Pipe do
  include Dry::Monads[:result]

  subject(:pipe) { described_class }

  describe "#call" do
    let(:doubler) { proc { |input| input.fmap { |value| value * 2 } } }

    let :composer do
      Class.new do
        include Transactable::Composable

        def initialize default = 1
          @default = default
        end

        def call(input) = input.fmap { |value| value - default }

        private

        attr_reader :default
      end
    end

    it "answers success with primitive input" do
      result = pipe.call 5, doubler
      expect(result).to eq(Success(10))
    end

    it "answers success with monad input" do
      result = pipe.call Success(5), doubler
      expect(result).to eq(Success(10))
    end

    it "answers failure when given a failure" do
      result = pipe.call Failure("Danger!"), doubler
      expect(result).to eq(Failure("Danger!"))
    end

    it "answers success for multiple function steps" do
      result = pipe.call 5, doubler, doubler, doubler
      expect(result).to eq(Success(40))
    end

    it "answers success for multiple method steps" do
      incrementer = Module.new { def self.incrementer(input) = input.fmap { |value| value + 1 } }
                          .method :incrementer
      result = pipe.call 5, incrementer, incrementer, incrementer

      expect(result.success).to eq(8)
    end

    it "answers success for multiple composable steps" do
      decrementer = composer.new
      result = pipe.call 5, decrementer, decrementer, decrementer

      expect(result.success).to eq(2)
    end

    it "fails with argument error when no steps are provided" do
      expectation = proc { pipe.call "test" }
      expect(&expectation).to raise_error(ArgumentError, /must have at least one step/)
    end

    it "fails with type error when step isn't a Proc, Method, or Step" do
      expectation = proc { pipe.call "test", Object.new }
      expect(&expectation).to raise_error(TypeError, /functionally composable.+monad/)
    end
  end
end
