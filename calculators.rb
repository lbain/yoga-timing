module Calculators
  require_relative 'sequence'

  # Run ALL the calculations
  def Calculators.calculate(total_time, total_moves, min_move_time)
    remaining_time, total_rounds = calculate_rounds(total_time, total_moves, min_move_time)
    move_time = calculate_move_time(min_move_time, remaining_time, total_moves, total_rounds)
    return total_rounds, move_time
  end

  private

  # calculate how many rounds the user can given their time frame
  def Calculators.calculate_rounds(total_time, total_moves, min_move_time)
    total_rounds = 0
    remaining_time = total_time * 60
    # try to get in as many rounds as possible given their time frame
    begin
      total_rounds += 1
      remaining_time -= total_moves * (min_move_time + total_rounds - 1)
    end while remaining_time > total_moves * (min_move_time + total_rounds)
    return remaining_time, total_rounds
  end

  # based on how much time is remaining, calculate how long
  # each pose should be held for in total
  def Calculators.calculate_move_time(min_move_time, remaining_time, num_moves, total_rounds)
    # calculate the base time for each pose
    total_moves = num_moves * total_rounds
    min_move_time + additional_time(remaining_time, total_moves)
  end

  # Any "left over" time not applied to full rounds can be added to individual poses
  def Calculators.additional_time(remaining_time, total_moves)
    remaining_time / (total_moves.to_f)
  end

end