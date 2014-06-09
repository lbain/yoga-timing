require 'rspec'
require 'rspec/autorun'
require 'benchmark'

require_relative '../yoga.rb'

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
