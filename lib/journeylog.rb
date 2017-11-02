require './lib/journey'

class JourneyLog
  attr_reader :log, :entry_station

  def initialize(minimum, penalty, journey_class: Journey, start: nil)
    @log = []
    @journey_class = journey_class
    @entry_station = start
    @minimum = minimum
    @penalty = penalty
  end

  def start(station)
    charge = fare(entry_station, nil) 
    @entry_station = station
    charge
  end

  def finish(exit_station)
    charge = fare(entry_station, exit_station)
    @entry_station = nil
    charge
  end

  def fare(entry_station, exit_station)
    commit(entry_station, exit_station)
    completed_journey? ? 0 : most_recent_fare
  end

  private

  def commit(entry_station, exit_station)
    unless completed_journey?
      log << @journey_class.new(entry_station, exit_station) 
    end
  end

  def completed_journey?
    entry_station.nil?
  end

  def most_recent_fare
    log.last.fare(@minimum, @penalty)
  end
end
