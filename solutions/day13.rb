# frozen_string_literal: true
require 'json'

def compare_items(left, right)
  # If the left side runs out of items first, the order is correct
  return -1 if left.nil? && !right.nil?
  return 1 if !left.nil? && right.nil?

  # If the items are bigger / smaller, it determines the order
  # Otherwise, it's undecided
  return 0 if left.is_a?(Integer) && right.is_a?(Integer) && left == right
  return -1 if left.is_a?(Integer) && right.is_a?(Integer) && left < right
  return 1 if left.is_a?(Integer) && right.is_a?(Integer) && left > right

  # If one of the items is a single integer, put it inside an array
  return compare_items([left], right) if left.is_a?(Integer) && !right.is_a?(Integer)
  return compare_items(left, [right]) if !left.is_a?(Integer) && right.is_a?(Integer)

  # If both items are arrays, go through them one by one
  validation = []
  (0..[left.length, right.length].max - 1).each do |index|
    item1 = left[index]
    item2 = right[index]
    current = compare_items(item1, item2)
    validation.push(current)
  end

  # Take the first non-zero result or return zero if undecided
  validation.detect { |v| v != 0 } || 0
end

pairs = File.read('../inputs/day13.txt')
            .split("\n\n")
            .map { |b| b.split("\n") }
            .map { |b| b.map { |p| JSON.parse(p) } }

# Create an extra array for the second part so we don't have to flatten it
answer1 = []
answer2 = []
pairs.each_with_index do |pair, index|
  left, right = pair
  valid = compare_items(left, right)
  answer1.push(index + 1) if valid == -1

  answer2.push(left)
  answer2.push(right)
end

# Add the extra dividers
divider1 = [[2]]
divider2 = [[6]]
answer2.push(divider1)
answer2.push(divider2)

# Order the items using the compare function and find the diviers
answer2.sort! { |a, b| compare_items(a, b) }

puts "Answer 1: #{answer1.sum}"
puts "Answer 2: #{(answer2.index(divider1) + 1) * (answer2.index(divider2) + 1)}"