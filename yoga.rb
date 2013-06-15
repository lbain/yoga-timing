require_relative 'extras'
require_relative 'calculators'
require_relative 'sequence'

# Get the base sequence from another file
# (don't want things to get too messy in here!)
# TODO: add other sequences and ask user what they want to do
sequence = File.read('default_sequence.rb')

# Note: eval is really dangerous, don't use it unless you have controll over
# what the program will evaluate
sequence = eval(sequence)

# what the user actually sees/here for each move
def give_move(move, side, delay)
  start = Time.now
  # system("say #{move} #{side}") #this is super slick on macs
  elapsed = Time.now - start
  delay -= elapsed
  puts "#{move} #{side}"
  puts "  hold for #{delay} seconds"
  # sleep(delay)
end


# basically the main() function
total_time = ARGV[0] || 10
total_time = total_time.to_i * 60
total_moves = 0
total_rounds, move_time = Calculators.calculate(sequence, total_time)

Sequence.run_practice(sequence, total_rounds, move_time)
