# frozen_string_literal: true

def find_repeating(input, length)
  # Start loop from the requested length - 1 (off by one because it's an index)
  # End the loop at the last char (because we look at elements backwards)
  start = length - 1
  finish = input.length - 1

  (start..finish).each { |i|
    # Get a substring from the current char and the previous ones
    l = i - (length - 1)
    r = i

    # Count occurrences of each element - the amount of different chars should equal to the length
    unique = input[l..r].each_char.tally.count
    return i + 1 if unique == length
  }
end

input = File.read('../inputs/day06.txt')
answer1 = find_repeating(input, 4)
answer2 = find_repeating(input, 14)

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2}"