# frozen_string_literal: true

require "spec_helper"

RSpec.describe Transactable::Instrument do
  subject(:instrument) { described_class.new }

  describe "#subscribe" do
    it "listens to step events" do
      instrument.publish "step", name: "test"

      instrument.subscribe "step" do |event|
        expect(event).to have_attributes(id: "step", payload: {name: "test"})
      end
    end

    it "listens to step success events" do
      instrument.publish "step.success", name: "test"

      instrument.subscribe "step.success" do |event|
        expect(event).to have_attributes(id: "step.success", payload: {name: "test"})
      end
    end

    it "listens to step failure events" do
      instrument.publish "step.failure", name: "test"

      instrument.subscribe "step.failure" do |event|
        expect(event).to have_attributes(id: "step.failure", payload: {name: "test"})
      end
    end
  end
end
