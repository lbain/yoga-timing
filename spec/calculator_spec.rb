require 'rspec'
require 'rspec/autorun'
require 'benchmark'

require_relative '../calculator.rb'

describe 'Calculator' do

  describe '#base_time_per_move' do
    let(:calculator) { Calculator.new(0, 1, 5) }
    it 'keeps the calculation for an individual move' do
      calculator.base_time_per_move(2).should == 6
    end
  end

  describe '#round_time' do
    let(:calculator) { Calculator.new(0, 10, 5) }
    it 'calculates how long the entire round would take' do
      calculator.round_time(2).should == 60
    end
  end

  describe '#num_rounds' do
    it 'calculates the number of full rounds it is possible to do in the time' do
      calculator = Calculator.new(9*60, 1, 1)
      calculator.stub(:round_time).and_return(60)
      calculator.num_rounds().should == 9
    end
  end

  describe '#time_left_over' do
    it 'tracks the amount of time left over' do
      calculator = Calculator.new(5*60, 1, 1)
      calculator.stub(:round_time).and_return(51)
      calculator.time_left_over().should == 45
    end
  end

  describe '#additional_time_per_move' do
    it 'allocates all the remaining time' do
      calculator = Calculator.new(5*60, 2, 1)
      calculator.stub(:time_left_over).and_return(10)
      calculator.stub(:num_rounds).and_return(5)
      calculator.additional_time_per_move().should == 1
    end
  end

  describe '#time_per_round' do
    before :each do
      @calculator = Calculator.new(5*60, 2, 1)
      @calculator.stub(:num_rounds).and_return(3)
      @calculator.stub(:additional_time_per_move).and_return(1)
    end

    it 'calculates the time for each round in the simple case' do
      @calculator.stub(:base_time_per_move).and_return(2)
      @calculator.time_per_round().should == {
        1 => 3,
        2 => 3,
        3 => 3
      }
    end

    it 'calculates the time for each round in the simple case' do
      @calculator.stub(:base_time_per_move).with(1).and_return(2)
      @calculator.stub(:base_time_per_move).with(2).and_return(3)
      @calculator.stub(:base_time_per_move).with(3).and_return(4)
      @calculator.time_per_round().should == {
        1 => 5,
        2 => 4,
        3 => 3
      }
    end
  end

  it 'can do a full simple calculation' do
    calculator = Calculator.new(3*60, 30, 1)
    calculator.time_per_round().should == {
        1 => 3.0,
        2 => 2.0,
        3 => 1.0
      }
  end

  it 'can do a full complex calculation' do
    calculator = Calculator.new(10*60, 32, 3)
    calculator.time_per_round().should == {
        1 => 6.1875,
        2 => 5.1875,
        3 => 4.1875,
        4 => 3.1875
      }
  end

  it 'adds up to the correct user time' do
    calculator = Calculator.new(5*60, 39, 3)
    total_time = 0
    puts calculator.time_per_round()
    calculator.time_per_round().each do |round, time|
      total_time += time * 39
    end
    total_time.should == 5 * 60
  end
end