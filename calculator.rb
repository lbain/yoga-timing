class Calculator
  require_relative 'sequence'

  def initialize(user_time, total_moves, min_move_time)
    @user_time = user_time
    @total_moves = total_moves
    @min_move_time = min_move_time
  end

  def time_per_round
    rounds = {}
    (1..num_rounds).each do |round|
      rounds[round] = base_time_per_move(num_rounds - round + 1) + additional_time_per_move
    end
    rounds
  end

  def user_time_in_secs
    @user_time
  end

  def num_rounds
    @num_rounds ||= round_calculations[0]
  end

  def time_left_over
    @time_left_over ||= round_calculations[1]
  end

  def base_time_per_move(round)
    @min_move_time + round - 1
  end

  def round_time(round)
    @total_moves * base_time_per_move(round)
  end

  def additional_time_per_move
    time_left_over/(num_rounds * @total_moves).to_f
  end

  private
  def round_calculations
    total_rounds = 0
    remaining_time = user_time_in_secs
    begin
      total_rounds += 1
      remaining_time -= round_time(total_rounds)
    end while remaining_time >= round_time(total_rounds + 1)
    return total_rounds, remaining_time
  end

end