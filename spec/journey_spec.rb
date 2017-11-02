require 'journey'

describe Journey do

  # mock stations
  let(:start) { double(:station, zone: 1)}
  let(:finish) { double(:station, zone: 3)}

  let(:normal_journey) { described_class.new(start, finish) }
  let(:no_in_journey)  { described_class.new(nil, finish) }
  let(:no_out_journey)  { described_class.new(start, nil) }
  let(:fares) { [1, 9] }

  it 'knows the entry station' do
    expect(normal_journey.entry_station).to eq start
  end

  it 'knows the exit station' do
    expect(normal_journey.exit_station).to eq finish
  end

  describe '#fare' do
    it 'returns the fare for the journey' do
      allow(normal_journey)
        .to receive(:calculate).and_return(:fare)
      expect(normal_journey.fare(*fares)).to eq :fare
    end

    it 'returns penalty when double touch out ' do
      expect(no_in_journey.fare(*fares)).to eq 9
    end

    it 'returns penalty when double touch in ' do
      expect(no_out_journey.fare(*fares)).to eq 9
    end
  end

  describe '#calculate' do
    it 'calculates the fare' do
      expect(normal_journey.calculate(1)).to eq 3
    end
  end
end
