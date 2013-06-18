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
puts "How long would you like to practice for (in minutes)?"
total_time = $stdin.gets.chomp.to_i * 60

puts "What sequence would you like to use?"
file_options = []
dir_contents = Dir.entries("./sequences").each do |f|
  file_options << f.gsub('.rb', '') unless f.start_with? "."
end
file_options.each_with_index do |file, i|
  puts "#{i+1}. #{file}"
end
file_number = $stdin.gets.chomp.to_i
file = file_options[file_number - 1]

#TODO: or max num of rounds
puts "What's the shortest length of time you want to hold a pose (in seconds)?"
min_move_time = $stdin.gets.chomp.to_i

puts "total_time = #{total_time}"
puts "file = #{file}"
puts "min_move_time = #{min_move_time}"

Sequence.new('./sequences/' + file + '.rb', total_time, min_move_time)
