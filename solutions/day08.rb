# frozen_string_literal: true
require 'matrix'

# Create a matrix from the input
lines = File.read('../inputs/day08.txt').split("\n")
numbers = lines.map { |l| l.chars.map { |c| c.to_i } }
matrix = Matrix.rows(numbers)

# For every row and column...
#   take the left / right / top / bottom part of the current item (selected by the row / col as index)
#   check if all items are smaller to either side - it makes the tree visible
#   count the number of visible trees
answer1 = 0
matrix.each_with_index do |item, row, col|
  left = matrix.row(row).filter_map.with_index { |i, x| i if x < col }
  right = matrix.row(row).filter_map.with_index { |i, x| i if x > col }
  up = matrix.column(col).filter_map.with_index { |i, x| i if x < row }
  down = matrix.column(col).filter_map.with_index { |i, x| i if x > row }
  visible = left.all? { |i| i < item } || right.all? { |i| i < item } || up.all? { |i| i < item } || down.all? { |i| i < item }
  answer1 += 1 if visible
end

# Build a new matrix with the same size
answer2 = Matrix.build(matrix.row_count, matrix.column_count) do |row, col|
  item = matrix[row,col]

  # Select the required part of the row / column, reverse so the first one is always closest to the current tree
  left = matrix.row(row).filter_map.with_index { |i, x| i if x < col }.reverse
  right = matrix.row(row).filter_map.with_index { |i, x| i if x > col }
  up = matrix.column(col).filter_map.with_index { |i, x| i if x < row }.reverse
  down = matrix.column(col).filter_map.with_index { |i, x| i if x > row }

  # This is an ugly hack, take_while only returns items up to the condition, so one is missing
  # Add plus one to the count to compensate for the missing item
  # Except for the places where it would be bigger than the entire array (on the edges, it adds one when there are no more items)
  l = [left.take_while { |i| i < item }.count + 1, left.count].min
  r = [right.take_while { |i| i < item }.count + 1, right.count].min
  u = [up.take_while { |i| i < item }.count + 1, up.count].min
  d = [down.take_while { |i| i < item }.count + 1, down.count].min

  # Multiply everything together
  l * r * u * d
end

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2.max}"