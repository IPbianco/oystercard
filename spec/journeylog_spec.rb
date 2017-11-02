require 'journeylog'

describe JourneyLog do

  let(:journey) { double(:journey, fare: 1) }
  let(:journey_class) { double(:journey_class, new: journey) }

  subject { described_class.new(journey_class: journey_class) }

  describe '#new' do
    context 'when created' do
      it 'has empty log array' do
        expect(subject.log).to eq Array.new
      end
      it 'has an entry_station defaulted to nil' do
        expect(subject.entry_station).to be_nil
      end
    end
  end
  
end
