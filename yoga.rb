require_relative 'sequence'
require 'io/console'

def char_if_pressed
  system("stty raw -echo")
  char = STDIN.read_nonblock(1) rescue nil
  system("stty -raw echo")
  char
end

def listen_for_pause(delay)
  for i in 0..delay*10
    c = char_if_pressed
    if c
      if /\s/ =~ c
        STDIN.getch
      elsif /\q/ =~ c
        exit
      end
    end
    sleep(0.1)
  end
end

# what the user actually sees/here for each move
def give_move(move, side, delay)
  start = Time.now
  system("say #{move} #{side}") #this is super slick on macs
  elapsed = Time.now - start
  delay -= elapsed
  puts "#{move} #{side}"
  puts "  hold for #{delay} seconds"
  listen_for_pause(delay)
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

puts "What's the shortest length of time you want to hold a pose (in seconds)?"
min_move_time = $stdin.gets.chomp.to_i

Sequence.new('./sequences/' + file + '.rb', total_time, min_move_time)
