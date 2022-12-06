# frozen_string_literal: true

def find_answer1(input)
  (3..input.length - 2).each { |i|
    str = input[i - 3..i]
    unique = str.each_char.tally.count
    return i + 1 if unique == 4
  }

  -1
end

input = File.read('../inputs/day06.txt')
answer1 = find_answer1(input)

puts "Answer 1: #{answer1}"