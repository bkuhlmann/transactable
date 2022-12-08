# frozen_string_literal: true

require "dry/container"
require "spec_helper"

RSpec.describe Transactable do
  describe ".included" do
    it "includes behavior" do
      implementation = Class.new.include described_class
      expect(implementation.ancestors).to include(described_class)
    end
  end

  describe ".with" do
    it "includes default behavior" do
      implementation = Class.new.include described_class.with
      expect(implementation.ancestors.join(", ")).to include(described_class.to_s)
    end

    it "includes custom behavior" do
      container = Dry::Container.new
      container.register(:echo) { -> result { result } }
      implementation = Class.new.include described_class.with(container)

      expect(implementation.ancestors.join(", ")).to include("Transactable::Pipeable")
    end
  end
end
