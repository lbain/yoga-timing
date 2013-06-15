require_relative 'extras'

# define constants
SIDES = ['left', 'right'] unless defined?(SIDES)

# Get the base sequence from another file
# (don't want things to get too messy in here!)
# TODO: add other sequences and ask user what they want to do
@sequence = File.read('default_sequence.rb')

# Note: eval is really dangerous, don't use it unless you have controll over
# what the program will evaluate
@sequence = eval(@sequence)

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

# run through the whole sequence (including right/left iterations)
# with a given block
def run_sequence
  @sequence.each do |move|
    if move.is_a? Hash
      move.each do |key, side_moves|
        SIDES.each do |side|
          side_moves.each do |sub|
            yield(sub, side)
          end
        end
      end
    else
      yield(move)
    end
  end
end

# calculate how many moves the sequence goes through in total
# (including right/left iterations)
def calculate_moves
  total_moves = 0
  run_sequence { |move| total_moves = total_moves + 1 }
  total_moves
end

# calculate how many rounds the user can given their time frame
def calculate_rounds(total_time, total_moves)
  total_rounds = 0
  remaining_time = total_time
  # try to get in as many rounds as possible given their time frame
  while remaining_time > total_moves * total_rounds * 2
    total_rounds += 1
    remaining_time -= total_moves * total_rounds * 2
    puts "total_rounds = #{total_rounds}"
    puts "total_moves = #{total_moves}"
    puts "remaining_time = #{remaining_time}"
  end
  return remaining_time, total_rounds
end

# based on how much time is remaining, calculate how long
# each pose should be held for in total
def calculate_move_time(remaining_time, total_moves, total_rounds)
  # Any "left over" time not applied to full rounds can be added to individual poses
  additional_time = remaining_time / (total_rounds.factorial * total_moves.to_f)
  puts "additional_time = #{additional_time}"
  # calculate the base time for each pose
  move_time = 2 + additional_time
  move_time
end

# Run ALL the calculations
def calculate(total_time)
  total_moves = calculate_moves
  remaining_time, total_rounds = calculate_rounds(total_time, total_moves)
  move_time = calculate_move_time(remaining_time, total_moves, total_rounds)
  return total_rounds, move_time
end

# ok, now all the relevant numbers have been crunched, run this thing!
def run_practice(total_rounds, move_time)
  (1..total_rounds).each do |round|
    round_side = round.even? ? SIDES.reverse : SIDES
    delay = (total_rounds - round + 1) * (move_time)
    run_sequence { |move, side| give_move(move, side, delay) }
  end
end

# basically the main() function
total_time = ARGV[0] || 10
total_time = total_time.to_i * 60

total_rounds, move_time = calculate(total_time)

run_practice(total_rounds, move_time)