# frozen_string_literal: true
require 'json'

def compare_items(left, right)
  return 0 if left.nil? && right.nil?
  return -1 if left.nil? && !right.nil?
  return 1 if !left.nil? && right.nil?

  return 0 if left.is_a?(Integer) && right.is_a?(Integer) && left == right
  return -1 if left.is_a?(Integer) && right.is_a?(Integer) && left < right
  return 1 if left.is_a?(Integer) && right.is_a?(Integer) && left > right

  return compare_items([left], right) if left.is_a?(Integer) && !right.is_a?(Integer)
  return compare_items(left, [right]) if !left.is_a?(Integer) && right.is_a?(Integer)

  validation = []
  (0..[left.length, right.length].max - 1).each do |index|
    item1 = left[index]
    item2 = right[index]
    current = compare_items(item1, item2)
    validation.push(current)
  end

  result = validation.detect { |v| v != 0 }
  result
end

pairs = File.read('../inputs/day13.txt')
            .split("\n\n")
            .map { |b| b.split("\n") }
            .map { |b| b.map { |p| JSON.parse(p) } }

answer1 = []
pairs.each_with_index do |pair, index|
  left, right = pair
  valid = compare_items(left, right)
  answer1.push(index + 1) if valid == -1
end

puts "Answer 1: #{answer1.sum}"