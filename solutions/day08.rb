# frozen_string_literal: true
require 'matrix'

lines = File.read('../inputs/day08.txt').split("\n")
numbers = lines.map { |l| l.chars.map { |c| c.to_i } }
matrix = Matrix.rows(numbers)

answer1 = 0
matrix.each_with_index do |item, row, col|
  left = matrix.row(row).filter_map.with_index { |i, x| i if x < col }
  right = matrix.row(row).filter_map.with_index { |i, x| i if x > col }
  up = matrix.column(col).filter_map.with_index { |i, x| i if x < row }
  down = matrix.column(col).filter_map.with_index { |i, x| i if x > row }
  visible = left.all? { |i| i < item } || right.all? { |i| i < item } || up.all? { |i| i < item } || down.all? { |i| i < item }
  answer1 += 1 if visible
end

puts "Answer 1: #{answer1}"