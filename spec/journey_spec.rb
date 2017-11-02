require 'journey'

describe Journey do
  let(:normal_journey) { described_class.new(4, 5) }
  let(:no_in_journey)  { described_class.new(nil, 5) }
  let(:no_out_journey)  { described_class.new(5, nil) }
  let(:fares) { [1, 9] }

  it 'knows the entry station' do
    expect(normal_journey.entry_station).to eq 4
  end

  it 'knows the exit station' do
    expect(normal_journey.exit_station).to eq 5
  end

  describe '#fare' do
    it 'returns the fare for the journey' do
      expect(normal_journey.fare(*fares)).to eq 1
    end

    it 'returns penalty when double touch out ' do
      expect(no_in_journey.fare(*fares)).to eq 9
    end

    it 'returns penalty when double touch in ' do
      expect(no_out_journey.fare(*fares)).to eq 9
    end
  end
end
