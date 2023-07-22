# frozen_string_literal: true

require "dry/monads"

module Transactable
  # Allows any object to pipe sequential steps together which can be composed into a single result.
  class Pipeable < Module
    def initialize steps = Steps::Container
      super()
      @steps = steps
      @instance_module = Class.new(Module).new
    end

    def included klass
      super
      define_pipe
      define_steps
      klass.include instance_module
    end

    private

    attr_reader :steps, :instance_module

    def define_pipe
      instance_module.define_method :pipe do |input, *steps|
        fail ArgumentError, "Transaction must have at least one step." if steps.empty?

        result = input.is_a?(Dry::Monads::Result) ? input : Dry::Monads::Success(input)

        steps.reduce(&:>>).call result
      rescue NoMethodError
        raise TypeError, "Step must be functionally composable and answer a monad."
      end
    end

    def define_steps
      instance_module.class_exec steps do |container|
        container.each_key do |name|
          define_method name do |*positionals, **keywords, &block|
            step = container[name]
            step.is_a?(Proc) ? step : step.new(*positionals, **keywords, &block)
          end
        end
      end
    end
  end
end
