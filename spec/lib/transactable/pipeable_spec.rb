# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Pipeable do
  subject(:pipeable) { implementation.new }

  describe "#call" do
    context "with single step (primitive)" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def call(input) = pipe input, as(:to_s)
        end
      end

      it "answers result" do
        result = pipeable.call "test"
        expect(result.success).to eq("test")
      end
    end

    context "with single step (monad)" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def call(input) = pipe Dry::Monads::Success(input), as(:to_s)
        end
      end

      it "answers result" do
        result = pipeable.call "test"
        expect(result.success).to eq("test")
      end
    end

    context "with a custom Proc step" do
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

    context "with step that is not a Proc or a Class" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def call(input) = pipe input, Object.new
        end
      end

      it "fails with invalid type" do
        expectation = proc { pipeable.call "test" }
        expect(&expectation).to raise_error(TypeError, /functionally composable.+monad/)
      end
    end

    context "with no steps" do
      let :implementation do
        Class.new do
          include Transactable::Pipeable.new

          def call(input) = pipe input
        end
      end

      it "fails with argument error" do
        expectation = proc { pipeable.call "test" }
        expect(&expectation).to raise_error(ArgumentError, /must have at least one step/)
      end
    end
  end
end
