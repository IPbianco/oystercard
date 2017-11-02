require 'journey'

describe Journey do
  subject(:journey) { described_class.new }

  context 'with no arguments' do
    it 'knows the entry station' do
      expect(journey.entry_station).to be_nil
    end

    it 'knows the exit station' do
      expect(journey.exit_station).to be_nil
    end
  end

  context 'with arguments' do
    subject(:journey) { described_class.new(entry_station: 4, exit_station: 5) }

    it 'knows the entry station' do
      expect(journey.entry_station).to eq 4
    end

    it 'knows the exit station' do
      expect(journey.exit_station).to eq 5
    end
  end
end
