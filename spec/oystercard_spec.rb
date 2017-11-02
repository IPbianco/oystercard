require 'oystercard'

describe Oystercard do

  # other mocks
  let(:station) { double(:station, name: 'Oxford', zone: 4) }
  let(:journey) { double(:journey, entry: :Waterloo, out: :Euston, fare: 1) }
  let(:log_class) { double(:log_class) }

  # oyster cards
  let(:blank) { described_class.new }
  let(:touched_out) { described_class.new(50, log_class: log_class) }
  let(:touched_in) do
    described_class.new(50, entry: station, log_class: log_class)
  end

  subject { blank }

  describe '#initialize' do
    context 'when given no arguments' do
      it 'has a balance equal to 0' do
        expect(subject.balance).to eq(0)
      end
    end

    context 'when given balance' do
      subject { touched_in }

      it 'has a balance equal to 50' do
        expect(subject.balance).to eq(50)
      end
    end

    it 'should have an empty list of journeys by default' do
      expect(subject.log).to eq
    end
  end

  describe '#top_up' do
    subject { blank }

    it 'top-ups balance by 5' do
      subject.top_up(5)
      expect(subject.balance).to eq 5
    end

    it 'raises and error when amount is above limit' do
      maximum_balance = Oystercard::CREDIT_LIMIT
      subject.top_up(maximum_balance)
      expect { subject.top_up(1) }.to raise_error RuntimeError
    end
  end

  describe '#in_journey?' do
    context 'when touched in' do
      subject { touched_in }

      it 'is in journey' do
        expect(subject).to be_in_journey
      end
    end

    context 'when touched out' do
      subject { touched_out }

      it 'is not in journey' do
        expect(subject).to_not be_in_journey
      end
    end
  end

  describe '#touch in' do

    context 'when has credit less than minimum balance' do
      subject { blank }

      it 'raises error if minimum balance is less than 1' do
        expect { subject.touch_in(station) }.to raise_error RuntimeError
      end
    end

    context 'when has enough credit, and touched out' do
      subject { touched_out }
      before(:each) { subject.touch_in(station) }

      it 'sets entry to passed station' do
        expect(subject.entry).to eq station
      end
    end

    context 'when starting a normal journey' do
      subject { touched_out }

      before(:each) do
        expect(subject).to_not receive(:log_journey).with(station, nil)
      end

      it 'doesn\'t attempt to log journey' do
        subject.touch_in(station)
      end
    end

    context 'when starting an abnormal journey' do
      subject { touched_in }

      before(:each) do
        expect(subject).to receive(:log_journey).with(station, nil)
      end

      it 'also attempts to log journey' do
        subject.touch_in(station)
      end
    end
  end

  describe '#touch out' do
    context 'when ending a journey' do
      subject { touched_in }

      before(:each) do
        expect(subject).to receive(:log_journey).with(station, station)
      end

      it 'attempts to log journey' do
        subject.touch_out(station)
      end
    end

    context 'when ending an unusual journey' do
      subject { touched_out }

      before(:each) do
        expect(subject).to receive(:log_journey).with(nil, station)
      end

      it 'attempts to log journey' do
        subject.touch_out(station)
      end
    end

    it 'makes entry station nil on touch out' do
      touched_in.touch_out(station)
      expect(touched_in.entry).to eq nil
    end
  end

  describe '#log_journey' do

    subject { touched_in }

    it 'stores the journey in log' do
      subject.touch_out(station)
      expect(touched_in.log.last).to eq journey
    end

    it 'deducts fare' do
      expect { subject.touch_out(station) }
        .to change { subject.balance }.by(-1)
    end

  end
end
