# frozen_string_literal: true

require "dry/events"
require "dry/container/stub"
require "infusible/stub"

RSpec.shared_context "with instrumentation" do
  using Infusible::Stub

  let(:instrument) { Transactable::Instrument.new }
  let(:event_inspector) { Struct.new(:step, :success, :failure, keyword_init: true).new }

  before do
    Transactable::Import.stub(instrument:)

    instrument.subscribe("step") { |event| event_inspector.step = event }
    instrument.subscribe("step.success") { |event| event_inspector.success = event }
    instrument.subscribe("step.failure") { |event| event_inspector.failure = event }
  end

  after { Transactable::Import.unstub(instrument:) }

  shared_examples "an instrument" do
    it "publishes step" do
      step.call Failure("test")
      expect(event_inspector.step).to have_attributes(id: "step")
    end
  end
end
