# frozen_string_literal: true

require "dry/monads"
require "spec_helper"

RSpec.describe Transactable::Steps::Abstract do
  include Dry::Monads[:result]

  describe ".new" do
    let(:implementation) { Class.new described_class }

    let :proof do
      /
        @instrument=.+Transactable::Instrument.+
        @marameters=Marameters,\s
        @base_positionals=\["test"\],\s
        @base_keywords=\{:label=>"Value"\},\s
        @base_block=\#<Proc
      /x
    end

    it "answers no attributes when not given" do
      step = implementation.new

      expect(step.inspect).to match(
        /
          @instrument=.+Transactable::Instrument.+
          @marameters=Marameters,\s
          @base_positionals=\[\],\s
          @base_keywords=\{\},\s
          @base_block=nil
        /x
      )
    end

    it "answers positional, keyword, and block attributes when given" do
      function = proc { "test" }
      step = implementation.new "test", label: "Value", &function

      expect(step.inspect).to match(proof)
    end
  end
end
