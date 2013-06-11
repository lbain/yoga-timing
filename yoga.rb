@sequence = [
  "mountain",
  "arms lifted",
  "forward fold",
  "half up",
  "forward fold",
  "lunge",
  "plank",
  "Chaturanga",
  "cobra",
  { sides: [
    "down dog",
    "lunge",
    "Warrior 1",
    "Warrior 2",
    "reverse warrior",
    "triangle",
    "Warrior 2",
    "Warrior 3",
    "Warrior 1",
    "lunge"]
    },
  "down dog",
  "Plank",
  { sides: [
    "side plank"]
    },
  "Plank",
  "chaturanga",
  "boat",
  "down dog",
  "folding",
  "arms lifted"
]
sequence = [ "Plank",
  "chaturanga",
  "boat",
  "down dog",
  "folding",
  "arms lifted"
]

class Integer
  def fact
    (1..self).reduce(:*)
  end
end

def give_move(move, side, delay)
  start = Time.now
  system("say #{move} #{side}")
  elapsed = Time.now - start
  delay -= elapsed
  puts "#{move} #{side}"
  puts "  hold for #{delay} seconds"
  # sleep(delay)
end

def run_sequence
  @sequence.each do |move|
    if move.is_a? Hash
      move.each do |key, side_moves|
        @sides.each do |side|
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

@sides = ["left", "right"]
total_time = ARGV[0].to_i * 60
total_rounds = 0

total_moves = 0
run_sequence { |move| total_moves = total_moves + 1 }
puts total_moves

# get as close as you can
while total_time > total_moves * total_rounds * 2
  total_rounds += 1
  total_time -= total_moves * total_rounds * 2
  puts "total_rounds = #{total_rounds}"
  puts "total_moves = #{total_moves}"
  puts "total_time = #{total_time}"
end

# use up the left over bits
additional_time = total_time / (total_rounds.fact * total_moves.to_f)
puts "additional_time = #{additional_time}"

(1..total_rounds).each do |round|
  @sides = round.even? ? @sides.reverse : @sides
  delay = (total_rounds - round + 1) * (2+additional_time)
  run_sequence { |move, side| give_move(move, side, delay) }
end