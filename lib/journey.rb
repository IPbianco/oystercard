class Journey
  attr_reader :entry_station, :exit_station

  def initialize(entry_station, exit_station)
    @entry_station = entry_station
    @exit_station = exit_station
  end

  def fare(minimum, penalty)
    entry_station && exit_station ? minimum : penalty 
  end
end
