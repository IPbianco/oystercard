class Oystercard
  attr_reader :balance, :limit, :entry_station, :list_of_journeys, :exit_station
  CREDIT_LIMIT = 120
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize(limit = CREDIT_LIMIT)
    @balance = 0
    @limit = limit
    @list_of_journeys = []
    @journey = {}
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def touch_in(station)
    message = 'Balance less than the minimum fare'
    raise message  if insufficient_balance?
    @entry_station = station
    @journey[[station.name, station.zone]] = nil
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station
    @journey[[@entry_station.name, @entry_station.zone]] = [station.name, station.zone]
    @entry_station = nil
    add_to_list
  end

  def in_journey?
    !!@entry_station
  end

  private

  def deduct(fare)
    message = 'Not enough money for the journey'
    raise message if insufficient_money?(fare)
    @balance -= fare
  end

  def overloads?(amount)
    @balance + amount > CREDIT_LIMIT
  end

  def insufficient_money?(fare)
    @balance - fare < 0
  end

  def insufficient_balance?
    @balance < MINIMUM_BALANCE
  end

  def add_to_list
    @list_of_journeys << @journey
  end
end
