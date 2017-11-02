require 'journeylog'

describe JourneyLog do

  # mock objects
  let(:journey) { double(:journey, fare: 1) }
  let(:journey_class) { double(:journey_class, new: journey) }
  let(:entry) { :entry }
  let(:finish) { :finish }

  # logs in two states
  let(:in_journey) do 
    described_class.new(1, 9, start: entry, journey_class: journey_class)
  end

  let(:out_journey) { described_class.new(1, 9, journey_class: journey_class) }


  describe '#new' do
    subject { out_journey } 

    context 'when created' do
      it 'has empty log array' do
        expect(subject.log).to eq Array.new
      end

      it 'has an entry_station defaulted to nil' do
        expect(subject.entry_station).to be_nil
      end
    end
  end

  describe '#start' do
    subject { out_journey }
  
    context 'when called at the start of a journey' do
      before(:each) { subject.start(entry) }

      it 'sets entry_station to station' do
        expect(subject.entry_station).to eq entry
      end
    end

    context 'when starting' do
      after(:each) { subject.start(entry) }

      it 'logs current journey' do
        expect(subject).to receive(:fare).with(nil, nil)
      end
    end
    
  end

  describe '#finish' do
    subject { in_journey }

    context 'when called at the end of a journey' do
      before(:each) { subject.finish(finish) }

      it 'sets entry_station to nil' do
        expect(subject.entry_station).to be_nil
      end
    end

    context 'when ending' do
      after(:each) { subject.finish(finish) }

      it 'logs current journey' do
        expect(subject).to receive(:fare).with(entry, finish)
      end
    end
  end

  describe '#fare' do
    context 'when starting new journey' do
      subject { out_journey }

      it 'should not commit anything to log' do
        expect { subject.fare(entry, nil) }
          .to change { subject.log.length }.by(0)
      end

      it 'should return fare of 0' do
        expect(subject.fare(entry, nil)).to eq 0
      end
    end

    context 'when called at any other time' do
      subject { in_journey }

      it 'should commit journey to log' do
        subject.fare(entry, finish)
        expect(subject.log.last).to eq journey
      end

      it 'should return fare of 1' do
        expect(subject.fare(entry, finish)).to eq 1
      end
    end
  end
end
