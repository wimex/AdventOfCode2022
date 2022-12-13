# frozen_string_literal: true
require 'json'

def compare_items(left, right)
  return true if !left.nil? && right.nil?
  return false if left.nil? && !right.nil?

  return left < right if left.is_a?(Integer) && right.is_a?(Integer)
  return compare_items([left], right) if left.is_a?(Integer) && !right.is_a?(Integer)
  return compare_items(left, [right]) if !left.is_a?(Integer) && right.is_a?(Integer)

  valid = true
  left.each_with_index do |item, index|
    valid = valid && compare_items(left[index], right[index])
    return false unless valid
  end

  true
end

pairs = File.read('../inputs/day13.txt')
            .split("\n\n")
            .map { |b| b.split("\n") }
            .map { |b| b.map { |p| JSON.parse(p) } }

answer1 = []
pairs.each_with_index do |pair, index|
  left, right = pair
  valid = compare_items(left, right)
  answer1.push(index + 1) if valid
end

puts "Answer 1: #{answer1.sum}"