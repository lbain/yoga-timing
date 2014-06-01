require 'rspec'
require 'rspec/autorun'
require 'benchmark'

require_relative '../yoga.rb'

describe 'Calculators' do
  let(:num_min) { 5 }
  let(:num_moves) { 42 }
  let(:min_move_time) { 2 }
  let(:correct_total_rounds) { 2 }
  let(:total_moves) { num_moves * correct_total_rounds }
  let(:correct_remaining_time) { 90 }
  let(:correct_additional_time) { 1.071 }
  let(:correct_move_time) { min_move_time + correct_additional_time }

  describe '#calculate_rounds' do
    it 'calculates how many rounds and the remaining time' do
      remaining_time, total_rounds = Calculators.calculate_rounds(num_min, num_moves, min_move_time)
      remaining_time.should == correct_remaining_time
      total_rounds.should == correct_total_rounds
    end
  end

  describe '#calculate_additional_time' do
    it 'calculates how much time to add to each move' do
      additional_time = Calculators.additional_time(correct_remaining_time, total_moves)
      additional_time.round(3).should == correct_additional_time
    end
  end

  describe '#calculate_move_time' do
    it 'calculates how much total time the shortest move is' do
      move_time = Calculators.calculate_move_time(min_move_time, correct_remaining_time,
                            num_moves, correct_total_rounds)
      move_time.round(3).should == correct_move_time.round(3)
    end
  end

  describe '#calculate' do
    it 'can calculate the total rounds' do
      total_rounds, move_time = Calculators.calculate(num_min, num_moves, min_move_time)
      total_rounds.should == correct_total_rounds
    end

    it 'can calculate the minmum move time' do
      total_rounds, move_time = Calculators.calculate(num_min, num_moves, min_move_time)
      move_time.round(3).should == correct_move_time.round(3)
    end
  end

  it 'all adds up as it should' do
    total_rounds, move_time = Calculators.calculate(num_min, num_moves, min_move_time)
    num_seconds = 0
    (1..total_rounds).each do |round|
      (1..num_moves).each do |move|
        num_seconds += (total_rounds - round) + move_time
      end
    end
    num_seconds.round(0).should == num_min * 60
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
    time.round(0).should == (given_time * 60).round(0)
  end
end
