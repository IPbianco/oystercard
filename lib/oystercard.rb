class Oystercard
  attr_reader :balance, :limit, :entry, :log
  CREDIT_LIMIT = 120
  MINIMUM_FARE = 1
  PENALTY = 9

  def initialize(balance = 0, limit: CREDIT_LIMIT, log_class: JourneyLog)
    @balance = balance
    @limit = limit
    @log = log_class.new
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    credit(amount)
  end

  def touch_in(entry_station)
    raise 'insufficient funds' if insufficient_balance?
    log_journey(entry, nil) unless entry.nil?
    @entry = entry_station
  end

  def touch_out(exit_station)
    log_journey(entry, exit_station)
    @entry = nil
  end

  def in_journey?
    !!@entry
  end

  def log_journey(entry_station, exit_station)
    log << @journey_class.new(entry_station, exit_station)
    deduct(log.last.fare(MINIMUM_FARE, PENALTY))
  end

  private

  def credit(amount)
    @balance += amount
  end

  def deduct(fare)
    @balance -= fare
  end

  def overloads?(amount)
    @balance + amount > CREDIT_LIMIT
  end

  def insufficient_balance?
    @balance < MINIMUM_FARE
  end
end
