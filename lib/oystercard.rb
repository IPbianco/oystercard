class Oystercard
  attr_reader :balance, :limit, :entry, :journey_log, :exit_station
  CREDIT_LIMIT = 120
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 1

  def initialize(balance = 0, limit: CREDIT_LIMIT, entry: nil)
    @balance = balance
    @limit = limit
    @entry = entry
    @journey_log = []
    @journey = {}
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    @balance += amount
  end

  def touch_in(entry_station)
    raise 'insufficient funds' if insufficient_balance?
    log_journey(entry, nil) unless entry.nil?
    @entry = entry_station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station
    @journey[[@entry_station.name, @entry_station.zone]] = [station.name, station.zone]
    @entry_station = nil
    add_to_list
  end

  def in_journey?
    !!@entry
  end

  def log_journey(entry_station, exit_station)
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
