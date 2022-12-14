# frozen_string_literal: true

def move_sand(screen, sand)
  x = sand[:x]
  y = sand[:y]
  return [true, -1, -1] if x + 1 >= 1000 || y + 1 >= 1000

  return [false, x, y + 1] if screen[y + 1][x] == "." || screen[y + 1][x] == "~"
  return [false, x - 1, y + 1] if screen[y + 1][x - 1] == "." || screen[y + 1][x - 1] == "~"
  return [false, x + 1, y + 1] if screen[y + 1][x + 1] == "." || screen[y + 1][x + 1] == "~"

  [true, x, y]
end

def simulate_sand(screen, emitter)
  sand = { x: emitter[:x], y: emitter[:y] }
  stuck = false
  while !stuck do
    stuck, x, y = move_sand(screen, sand)
    return false if stuck && x < 0 || y < 0

    screen[y][x] = "o" if stuck
    screen[y][x] = "~" if !stuck

    sand = { x: x, y: y }
  end

  true
end

screen = Array.new(1000) { Array.new(1000) { "." } }
coords = File.read("../inputs/day14.txt")
             .split("\n")
             .map { |l| l.split(" -> ") }
             .map { |l| l.map { |g| g.split(",").map { |c| c.to_i } } }

coords.each do |line|
  line.each_cons(2).each do |coord|
    xdiff = coord[1][0] - coord[0][0]
    ydiff = coord[1][1] - coord[0][1]

    0.step(to: xdiff, by: xdiff < 0 ? -1 : 1).each do |m|
      x = coord[0][0] + m
      y = coord[0][1]
      screen[y][x] = "#"
    end
    0.step(to: ydiff, by: ydiff < 0 ? -1 : 1).each do |m|
      x = coord[0][0]
      y = coord[0][1] + m
      screen[y][x] = "#"
    end
  end
end

answer1 = 0
while simulate_sand(screen, { x: 500, y: 0 })
  answer1 += 1
end

puts "Answer 1: #{answer1}"