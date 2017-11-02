class Journey
  attr_reader :entry_station, :exit_station

  def initialize(entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def fare(minimum, penalty)
    entry_station && exit_station ? calculate(minimum) : penalty
  end

  def calculate(minimum)
    minimum + zones_crossed
  end

  private

  def zones_crossed
    (entry_station.zone - exit_station.zone).abs
  end
end
