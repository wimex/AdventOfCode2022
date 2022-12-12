# frozen_string_literal: true
require 'matrix'

def should_visit(map, x, y, d, w)
  return false if x < 0 || y < 0
  return false if map[y].nil? || map[y][x].nil?
  item = map[y][x]
  level = if item[:l] != -28 then item[:l] else 26 end
  distance = item[:d]
  d < distance && level <= w
end

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

def flood_route(map, tile)
  changes = []
  while !tile.nil? do
    wall = if tile[:l] == -28 then 26 elsif tile[:l] == -14 then 0 else tile[:l] + 1 end
    cursor = { x: tile[:x], y: tile[:y], d: tile[:d], w: wall }
    changes +=  update_distances(map, cursor)
    tile = changes.shift
  end
end

map = File.read('../inputs/day12.txt')
          .split("\n")
          .each_with_index
          .map { |l, r| [r, l.split("")] }
          .map { |r, l| l.each_with_index.map { |t, c| { x: c, y: r, l: t.ord - 97, d: 9999, v: false } } }

start_y, start_x = map.flatten.index { |t| t[:l] == -14 }.divmod(map[0].length)
end_y, end_x = map.flatten.index { |t| t[:l] == -28 }.divmod(map[0].length)

map[start_y][start_x][:d] = 0
flood_route(map, map[start_y][start_x])

puts "Answer 1: #{map[end_y][end_x][:d]}"