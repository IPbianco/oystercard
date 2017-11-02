require './lib/journeylog'

class Oystercard
  attr_reader :balance, :limit, :entry, :log
  CREDIT_LIMIT = 120
  MINIMUM_FARE = 1
  PENALTY = 9

  def initialize(balance = 0, limit: CREDIT_LIMIT, log_class: JourneyLog)
    @balance = balance
    @limit = limit
    @log = log_class.new(MINIMUM_FARE, PENALTY)
  end

  def top_up(amount)
    raise "amount above #{CREDIT_LIMIT}" if overloads?(amount)
    credit(amount)
  end

  def touch_in(entry_station)
    raise 'insufficient funds' if insufficient_balance?
    deduct(log.start(entry_station))
  end

  def touch_out(exit_station)
    deduct(log.finish(exit_station))
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
