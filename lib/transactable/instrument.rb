# frozen_string_literal: true

require "dry/events"

module Transactable
  # Provides a common instrument for subscribing to and publishing of events.
  class Instrument
    include Dry::Events::Publisher[name]

    EVENTS = %w[step step.success step.failure].freeze

    def initialize events: EVENTS
      events.each { |name| register_event name }
    end
  end
end
