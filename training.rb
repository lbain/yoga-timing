require 'date'
require_relative 'sequence'

# what the user actually sees/here for each move
def give_move(move, side, delay)
  start = Time.now
  system("say #{move} #{side}") #this is super slick on macs
  elapsed = Time.now - start
  delay -= elapsed
  puts "#{move} #{side}"
  puts "  hold for #{delay} seconds"
  sleep(delay)
end

week = (Date.new(2014,6,2)..Date.today).to_a.count / 7
mins = 10 + week


Sequence.new('./sequences/training.rb', mins * 60, 2)