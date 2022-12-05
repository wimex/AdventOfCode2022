# frozen_string_literal: true

def mover9000(stacks, moves)
  moves.each do |l|
    # Read the numbers from the sentence
    move = l.scan(/\d+/).map { |n| n.to_i }

    # The first number is the amount of items to move
    (0..move[0] - 1).each do |_|
      # Pop the selected item then push it to the other stack
      item = stacks[move[1] - 1].pop
      stacks[move[2] - 1].push(item)
    end
  end
end

def mover9001(stacks, moves)
  moves.each do |l|
    # Read the numbers from the sentence
    move = l.scan(/\d+/).map { |n| n.to_i }

    crates = []
    (0..move[0] - 1).each do |_|
      # Pop the selected item then push it to a temporary stack (reverses order)
      item = stacks[move[1] - 1].pop
      crates.push item
    end

    # Push items from the temporary stack to the new place (reverses order again - so back to normal)
    while !crates.empty? do
      stacks[move[2] - 1].push(crates.pop)
    end
  end
end

lines = File.read('../inputs/day05.txt')
chunks = lines.split("\n\n")

stacks1 = []
stacks2 = []

init = chunks[0].split("\n")
init.reverse.drop(1).each do |s|
  # Calculate number of stacks: every column takes 4 characters except for the last one which takes 3
  n = (s.length + 1) / 4

  # Start from the second char (where the first column is) and take every fourth character (every column)
  j = 1
  (0..n - 1).each do |i|
    stacks1[i] = [] if stacks1[i].nil?
    stacks2[i] = [] if stacks2[i].nil?
    stacks1[i].push(s[j]) unless s[j] == " "
    stacks2[i].push(s[j]) unless s[j] == " "
    j += 4
  end
end

commands = chunks[1].split("\n")
mover9000(stacks1, commands)
mover9001(stacks2, commands)

# Join the last items of every stack (which is the top in this case)
answer1 = stacks1.map { |s| s.last }.join
answer2 = stacks2.map { |s| s.last }.join

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2}"