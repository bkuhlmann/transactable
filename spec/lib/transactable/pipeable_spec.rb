# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Pipeable do
  subject(:pipeable) { implementation.new }

  describe "#call" do
    context "with a custom function step" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new({echo: -> result { result }})

          def call(input) = pipe input, echo
        end
      end

      it "answers result" do
        result = pipeable.call "test"
        expect(result.success).to eq("test")
      end
    end

    context "with multiple steps" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def call(input) = pipe input, insert("a", at: 0), insert("b")
        end
      end

      it "answers result" do
        result = pipeable.call "test"
        expect(result.success).to eq(%w[a test b])
      end
    end

    context "with multiple method steps" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def initialize seed = 5
            @seed = seed
          end

          def call(input) = pipe input, method(:add), method(:multiply)

          private

          attr_reader :seed

          def add(result) = result.fmap { |value| seed + value }

          def multiply(result) = result.fmap { |value| seed * value }
        end
      end

      it "answers result" do
        result = pipeable.call 10
        expect(result.success).to eq(75)
      end
    end

    context "with multiple symbol steps" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def initialize seed = 5
            @seed = seed
          end

          def call(input) = pipe input, :add, :multiply

          private

          attr_reader :seed

          def add(result) = result.fmap { |value| seed + value }

          def multiply(result) = result.fmap { |value| seed * value }
        end
      end

      it "answers result" do
        result = pipeable.call 10
        expect(result.success).to eq(75)
      end
    end
  end
end
