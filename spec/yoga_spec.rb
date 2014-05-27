require 'rspec'
require 'rspec/autorun'
require 'benchmark'

require_relative '../yoga.rb'

describe 'Calculators' do
  let(:num_min) { 5 }
  let(:num_moves) { 42 }
  let(:min_move_time) { 1 }
  let(:correct_total_rounds) { 3 }
  let(:total_moves) { num_moves * correct_total_rounds.factorial }
  let(:correct_remaining_time) { 48 }
  let(:correct_move_time) { min_move_time + (correct_remaining_time/total_moves.to_f) }

  describe '#calculate_rounds' do
    it 'calculates how many rounds and the remaining time' do
      remaining_time, total_rounds = Calculators.calculate_rounds(num_min, num_moves, min_move_time)
      remaining_time.should == correct_remaining_time
      total_rounds.should == correct_total_rounds
    end
  end

  describe '#calculate_move_time' do
    it 'calculates how much time to add to each move' do
      Calculators.calculate_move_time(min_move_time, correct_remaining_time,
                    num_moves, correct_total_rounds).should == correct_move_time
    end
  end

  describe '#calculate' do
    it 'can calculate the total rounds and each move time' do
      total_rounds, move_time = Calculators.calculate(num_min, num_moves, min_move_time)
      total_rounds.should == correct_total_rounds
      move_time.should == correct_move_time
    end
  end
end

describe '#give_move' do
  let(:given_time) { 2 }

  it 'waits exactly the right length of time' do
    time = Benchmark.realtime { give_move("test", "right", given_time) }
    time.round(1).should == given_time.round(1)
  end
end

describe 'full run through' do
  let(:given_time) { 5 }
  it 'runs for the right time' do
    time = Benchmark.realtime { Sequence.new('./sequences/default.rb', given_time, 3) }
    time.round(1).should == (given_time * 60).round(1)
  end
end
