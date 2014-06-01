class Sequence
  require_relative 'calculators'
  require_relative 'extras'

  attr_accessor :sequence
  @sequence

  def initialize(sequence_file, total_time, min_move_time)
    # Get the base sequence from another file
    # (don't want things to get too messy in here!)
    sequence = File.read(sequence_file)

    # Note: eval is really dangerous, don't use it unless you have controll over
    # what the program will evaluate
    @sequence = eval(sequence)
    run_practice(total_time, min_move_time)
  end

  # define constants
  SIDES = ['left', 'right'] unless defined?(SIDES)

  # calculate how many moves the sequence goes through in total
  # (including right/left iterations)
  def count_moves
    total_moves = 0
    run_sequence(nil, ->(move, side) { total_moves = total_moves + 1 } )
    total_moves
  end

  # run through the whole sequence (including right/left iterations)
  # with a given proc
  def run_sequence(round_sides, proc)
    round_sides ||= SIDES
    @sequence.each do |move|
      if move.is_a? Hash
        move.each do |key, side_moves|
          round_sides.each do |side|
            side_moves.each do |sub|
              proc.call(sub, side)
            end
          end
        end
      else
        proc.call(move, nil)
      end
    end
  end

  # ok, now all the relevant numbers have been crunched, run this thing!
  def run_practice(total_time, min_move_time)
    total_moves = count_moves()
    total_rounds, move_time = Calculators.calculate(total_time, total_moves, min_move_time)
    puts "total_rounds = #{total_rounds}"
    (1..total_rounds).each do |round|
      round_sides = round.even? ? SIDES.reverse : SIDES
      delay = (total_rounds - round) + move_time
      puts "delay = #{delay}"
      run_sequence(round_sides, ->(move, side) { give_move(move, side, delay) } )
    end
  end
end