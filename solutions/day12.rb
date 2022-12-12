# frozen_string_literal: true
require 'matrix'

def should_visit(map, x, y, d)
  return false if x < 0 || y < 0
  return false if map[y].nil? || map[y][x].nil?
  s = map[y][x][:d]
  d < s
end

def update_distances(map, cursor)
  x = cursor[:x]
  y = cursor[:y]
  d = cursor[:d]
  w = cursor[:w]

  return if x < 0 || y < 0
  return if map[y].nil? || map[y][x].nil?

  item = map[y][x]
  level = if item[:l] != -28 then item[:l] else 26 end
  return if level > w

  item[:d] = [d, item[:d]].min

  update_distances(map, { x: x + 1, y: y, d: d + 1, w: w }) if should_visit(map, x + 1, y, d + 1)
  update_distances(map, { x: x, y: y + 1, d: d + 1, w: w }) if should_visit(map, x, y + 1, d + 1)
  update_distances(map, { x: x - 1, y: y, d: d + 1, w: w }) if should_visit(map, x - 1, y, d + 1)
  update_distances(map, { x: x, y: y - 1, d: d + 1, w: w }) if should_visit(map, x, y - 1, d + 1)
end

def flood_route(map)
  while map.flatten.any? { |t| t[:d] == 9999 && t[:l] == -28 } do
    candidates = []
    map.each_with_index do |r, row|
      r.each_with_index do |c, col|
        next if c[:d] == 9999
        candidates.append({ x: col, y: row, t: c })
      end
    end

    candidates.each do |c|
      tile = c[:t]
      wall = if tile[:l] == -28 then 26 elsif tile[:l] == -14 then 0 else tile[:l] + 1 end
      dstn = tile[:d]

      cursor = { x: c[:x], y: c[:y], d: dstn, w: wall }
      update_distances(map, cursor)
    end
  end
end

map = File.read('../inputs/day12.txt')
          .split("\n")
          .map { |l| l.split("") }
          .map { |l| l.map { |c| { l: c.ord - 97, d: 9999, v: false } } }

start_y, start_x = map.flatten.index { |t| t[:l] == -14 }.divmod(map[0].length)
end_y, end_x = map.flatten.index { |t| t[:l] == -28 }.divmod(map[0].length)

map[start_y][start_x][:d] = 0
flood_route(map)

puts "Answer 1: #{map[end_y][end_x][:d]}"