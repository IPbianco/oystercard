require 'oystercard'

describe Oystercard do

  # other mocks
  let(:station) { double(:station, name: 'Oxford', zone: 4) }
  let(:log) { double(:log, start: 0, finish: 1) }
  let(:log_class) { double(:log_class, new: log) }

  # oyster cards
  let(:blank) { described_class.new(log_class: log_class) }
  let(:topped_up) { described_class.new(50, log_class: log_class) }

  subject { blank }

  describe '#initialize' do
    context 'when given no arguments' do
      it 'has a balance equal to 0' do
        expect(subject.balance).to eq(0)
      end
    end

    context 'when given balance' do
      subject { topped_up }

      it 'has a balance equal to 50' do
        expect(subject.balance).to eq(50)
      end
    end

    it 'should have log object' do
      expect(subject.log).to eq log
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

  describe '#touch in' do
    context 'when has credit less than minimum balance' do
      subject { blank }

      it 'raises error if minimum balance is less than 1' do
        expect { subject.touch_in(station) }.to raise_error RuntimeError
      end
    end

    context 'when has enough credit, and touched out' do
      subject { topped_up }
      after(:each) { subject.touch_in(station) }

      it 'sends station to log class' do
        expect(subject.log).to receive(:start).with(station)
      end

      it 'changes balance by 0' do
        subject.touch_in(station)
        expect(subject.balance).to eq 50
      end
    end
  end

  describe '#touch in' do
    context 'when has enough credit, and touched out' do
      subject { topped_up }
      after(:each) { subject.touch_out(station) }

      it 'sends station to log class' do
        expect(subject.log).to receive(:finish).with(station)
      end

      it 'changes balance by 1' do
        subject.touch_out(station)
        expect(subject.balance).to eq 49
      end
    end
  end
end
