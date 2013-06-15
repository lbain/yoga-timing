require_relative 'sequence'

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

# TODO: add other sequences and ask user what they want to do
Sequence.new('default_sequence.rb', total_time)
