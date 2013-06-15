module Calculators
  require_relative 'sequence'

  # Run ALL the calculations
  def Calculators.calculate(sequence, total_time)
    total_moves = calculate_moves(sequence)
    remaining_time, total_rounds = calculate_rounds(total_time, total_moves)
    move_time = calculate_move_time(remaining_time, total_moves, total_rounds)
    return total_rounds, move_time
  end

  private

  # calculate how many moves the sequence goes through in total
  # (including right/left iterations)
  def Calculators.calculate_moves(sequence)
    total_moves = 0
    Sequence.run_sequence(sequence, nil, ->(move, side) { total_moves = total_moves + 1 } )
    total_moves
  end

  # calculate how many rounds the user can given their time frame
  def Calculators.calculate_rounds(total_time, total_moves)
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
  def Calculators.calculate_move_time(remaining_time, total_moves, total_rounds)
    # Any "left over" time not applied to full rounds can be added to individual poses
    additional_time = remaining_time / (total_rounds.factorial * total_moves.to_f)
    puts "additional_time = #{additional_time}"
    # calculate the base time for each pose
    move_time = 2 + additional_time
    move_time
  end
end