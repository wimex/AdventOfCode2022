# frozen_string_literal: true

stacks = []

lines = File.read('../inputs/day05.txt')
chunks = lines.split("\n\n")

init = chunks[0].split("\n")
init.reverse.drop(1).each do |s|
  # Calculate number of stacks: every column takes 4 characters except for the last one which takes 3
  n = (s.length + 1) / 4

  # Start from the second char (where the first column is) and take every fourth character (every column)
  j = 1
  (0..n - 1).each do |i|
    stacks[i] = [] if stacks[i].nil?
    stacks[i].push(s[j]) unless s[j] == " "
    j += 4
  end
end

chunks[1].split("\n").each do |l|
  # Read the numbers from the sentence
  move = l.scan(/\d+/).map { |n| n.to_i }

  # The first number is the amount of items to move
  (0..move[0] - 1).each do |_|
    # Pop the selected item then push it to the other stack
    item = stacks[move[1] - 1].pop
    stacks[move[2] - 1].push(item)
  end
end

# Join the last items of every stack (which is the top in this case)
answer1 = stacks
  .map{|s| s.last}
  .join

puts "Answer 1: #{answer1}"