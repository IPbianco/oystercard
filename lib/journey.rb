class Journey
  attr_reader :entry_station, :exit_station

  def initialize(entry_station: nil, exit_station: nil)
    @entry_station = entry_station
    @exit_station = exit_station
  end
end
