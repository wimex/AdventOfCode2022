# frozen_string_literal: true

# Checks if sand has fallen into the abyss
def finished_answer1(_, stuck, x, y)
  stuck && x < 0 || y < 0
end

# Checks if sand has been stuck on the emitter
def finished_answer2(emitter, stuck, x, y)
  stuck && x == emitter[:x] && y == emitter[:y]
end

# Moves the sand based on the rules
#   - try moving it down (y - 1)
#   - try moving it to the left (x - 1)
#   - try moving it to the right (x + 1)
#
# If none of this works, the sand is stuck, return the current coordinates
def move_sand(screen, sand)
  x = sand[:x]
  y = sand[:y]
  return [true, -1, -1] if x + 1 >= screen[0].length || y + 1 >= screen.length

  # Sand can flow through if there is a . (air) or ~ (previous path)
  return [false, x, y + 1] if screen[y + 1][x] == "." || screen[y + 1][x] == "~"
  return [false, x - 1, y + 1] if screen[y + 1][x - 1] == "." || screen[y + 1][x - 1] == "~"
  return [false, x + 1, y + 1] if screen[y + 1][x + 1] == "." || screen[y + 1][x + 1] == "~"

  # The sand is stuck
  [true, x, y]
end

# Simulate one piece of sand until it gets stuck
def simulate_sand(screen, emitter, check_finished)
  sand = { x: emitter[:x], y: emitter[:y] }
  stuck = false
  while !stuck do
    stuck, x, y = move_sand(screen, sand)
    return false if check_finished.call(emitter, stuck, x, y)

    # If the sand is stuck, mark it with an o
    # If it's not stuck, draw the path it takes (just for fun)
    screen[y][x] = "o" if stuck
    screen[y][x] = "~" if !stuck

    # The sand is now at the next coordinate
    sand = { x: x, y: y }
  end

  true
end

screen1 = Array.new(200) { Array.new(700) { "." } }
screen2 = Array.new(200) { Array.new(700) { "." } }
coords = File.read("../inputs/day14.txt")
             .split("\n")
             .map { |l| l.split(" -> ") }
             .map { |l| l.map { |g| g.split(",").map { |c| c.to_i } } }

# Parse the coords, draw lines
coords.each do |line|
  line.each_cons(2).each do |coord|
    xdiff = coord[1][0] - coord[0][0]
    ydiff = coord[1][1] - coord[0][1]

    # Draw line to the left or to the right
    0.step(to: xdiff, by: xdiff < 0 ? -1 : 1).each do |m|
      x = coord[0][0] + m
      y = coord[0][1]
      screen1[y][x] = "#"
      screen2[y][x] = "#"
    end

    # Draw line up or down
    0.step(to: ydiff, by: ydiff < 0 ? -1 : 1).each do |m|
      x = coord[0][0]
      y = coord[0][1] + m
      screen1[y][x] = "#"
      screen2[y][x] = "#"
    end
  end
end

# Draw the floor to the second screen
floor_y = coords.map { |c| c.map { |x| x[1] } }.flatten.max + 2
0.step(to: screen2[0].length - 1, by: 1).each do |x|
  screen2[floor_y][x] = "#"
end

answer1 = 0
while simulate_sand(screen1, { x: 500, y: 0 }, method(:finished_answer1))
  answer1 += 1
end

answer2 = 0
while simulate_sand(screen2, { x: 500, y: 0 }, method(:finished_answer2))
  answer2 += 1
end

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2 + 1}"

# Dump the finished screen just for fun
File.open("screen1.txt",'w'){ |f| f << screen1.map{ |row| row.join() }.join("\n") }
File.open("screen2.txt",'w'){ |f| f << screen2.map{ |row| row.join() }.join("\n") }