# frozen_string_literal: true
require 'matrix'

# Check if a tile should be visited
#  - it should be inside the bounds of the array
#  - it should have a level that's not too high
#  - it should be on a shorter route
def should_visit(map, x, y, d, w)
  return false if x < 0 || y < 0
  return false if map[y].nil? || map[y][x].nil?
  item = map[y][x]
  level = if item[:l] != -28 then item[:l] else 26 end
  distance = item[:d]
  d < distance && level <= w
end

# Update the distances around the current tile
def update_distances(map, cursor)
  x = cursor[:x]
  y = cursor[:y]
  d = cursor[:d]
  w = cursor[:w]

  left = map[y][x - 1] if should_visit(map, x - 1, y, d + 1, w)
  right = map[y][x + 1] if should_visit(map, x + 1, y, d + 1, w)
  top = map[y - 1][x] if should_visit(map, x, y - 1, d + 1, w)
  bottom = map[y + 1][x] if should_visit(map, x, y + 1, d + 1, w)

  left[:d] = d + 1 unless left.nil?
  right[:d] = d + 1 unless right.nil?
  top[:d] = d + 1 unless top.nil?
  bottom[:d] = d + 1 unless bottom.nil?

  [left, right, top, bottom].filter { |t| !t.nil? }
end

# Instead of proper trace routing (slow) just flood until we run into a wall
# While there are changed tiles, update the distances around the current tile
def flood_route(map, tile)
  changes = []

  while !tile.nil? do
    wall = if tile[:l] == -28 then 26 elsif tile[:l] == -14 then 0 else tile[:l] + 1 end
    cursor = { x: tile[:x], y: tile[:y], d: tile[:d], w: wall }

    changes += update_distances(map, cursor)
    tile = changes.shift
  end
end

map = File.read('../inputs/day12.txt')
          .split("\n")
          .each_with_index
          .map { |l, r| [r, l.split("")] }
          .map { |r, l| l.each_with_index.map { |t, c| { x: c, y: r, l: t.ord - 97, d: 9999, v: false } } }

starts = map.flatten.filter { |t| t[:l] == -14 || t[:l] == 0 }
end_y, end_x = map.flatten.index { |t| t[:l] == -28 }.divmod(map[0].length)
results = []

while !starts.empty?
  map.flatten.each { |m| m[:d] = 9999 } # Reset distances - let's just use an arbitrary value instead of INT_MAX

  current = starts.shift
  current[:d] = 0

  flood_route(map, current)
  results.push({ x: current[:x], y: current[:y], l: current[:l], d: map[end_y][end_x][:d] })
end

puts "Answer 1: #{results.filter { |r| r[:l] == -14 }.first[:d]}"
puts "Answer 2: #{results.map { |r| r[:d] }.min}"