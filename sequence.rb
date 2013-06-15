module Sequence

  # define constants
  SIDES = ['left', 'right'] unless defined?(SIDES)

  # run through the whole sequence (including right/left iterations)
  # with a given proc
  def Sequence.run_sequence(sequence, round_sides, proc)
    round_sides ||= SIDES
    sequence.each do |move|
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
  def Sequence.run_practice(sequence, total_rounds, move_time)
    (1..total_rounds).each do |round|
      round_sides = round.even? ? SIDES.reverse : SIDES
      delay = (total_rounds - round + 1) * (move_time)
      Sequence.run_sequence(sequence, round_sides, ->(move, side) { give_move(move, side, delay) } )
    end
  end
end