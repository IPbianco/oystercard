require 'journey'

class JourneyLog
  def initialize(journey_class: Journey)
    @log = []
    @journey_class = journey_class
  end
end
