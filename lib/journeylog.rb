require 'journey'

class JourneyLog
  attr_reader :log, :entry_station
  def initialize(journey_class: Journey)
    @log = []
    @journey_class = journey_class
    @entry_station = nil
  end
end
