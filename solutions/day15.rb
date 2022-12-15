# frozen_string_literal: true
# This is something straight from hell
# It's slow (~2 mins) and uses a lot of memory (~8 GB)

sensors = []
beacons = []

lines = File.read("../inputs/day15.txt")
            .split("\n")
            .map { |l| l.scan /-?\d+/ }
            .map { |l| l.map { |d| d.to_i } }

lines.each do |l|
  distance = (l[2] - l[0]).abs + (l[1] - l[3]).abs
  sensors.push({ sx: l[0], sy: l[1], bx: l[2], by: l[3], di: distance })
  beacons.push({ x: l[2], y: l[3] })
end

# Go through every point on the line and check if it's on any of the planes
# The y coordinate was provided but the x coordinate was chosen by trial and error
answer1 = 0
y = 2000000
-1000000.step(to: 9000000, by: 1).each do |x|
  sensors.zip(beacons) do |sensor, beacon|
    beacon_distance = (beacon[:x] - sensor[:sx]).abs + (beacon[:y] - sensor[:sy]).abs
    point_distance = (x - sensor[:sx]).abs + (y - sensor[:sy]).abs

    if point_distance <= beacon_distance && !(x == beacon[:x] && y == beacon[:y]) then
      answer1 += 1
      break
    end
  end
end

puts "Answer 1: #{answer1}"

# Go through every plane and collect all the points directly next to the plane
# These points are the candidate points
# This is pretty slow but works
edges = []
sensors.each_with_index do |sensor, index|
  puts "Checking sensor #{index}, found #{edges.length} edge points"

  startx = sensor[:sx] - sensor[:di] - 1
  starty = sensor[:sy] - sensor[:di] - 1
  endx = sensor[:sx] + sensor[:di] + 1
  endy = sensor[:sy] + sensor[:di] + 1

  x1 = startx
  x3 = endx
  x2 = sensor[:sx]
  x4 = sensor[:sx]

  y2 = starty
  y4 = endy
  y1= sensor[:sy]
  y3 = sensor[:sy]

  while y3 <= endy
    edges.push({ x: x1, y: y1 }) if x1 >= 0 && y1 >= 0 && x1 <= 4000000 && y1 <= 4000000
    edges.push({ x: x2, y: y2 }) if x2 >= 0 && y2 >= 0 && x2 <= 4000000 && y2 <= 4000000
    edges.push({ x: x3, y: y3 }) if x3 >= 0 && y3 >= 0 && x3 <= 4000000 && y3 <= 4000000
    edges.push({ x: x4, y: y4 }) if x4 >= 0 && y4 >= 0 && x4 <= 4000000 && y4 <= 4000000

    x1 += 1
    y1 -= 1

    x2 += 1
    y2 += 1

    x3 -= 1
    y3 += 1

    x4 -= 1
    y4 -= 1
  end
end

puts "Total #{edges.length} points"

# Go through every candidate and check if it's far enough from every sensor
answer2 = 0
edges.each do |edge|
  invisible = sensors.all? do |sensor|
    distance = (sensor[:sx] - edge[:x]).abs + (sensor[:sy] - edge[:y]).abs
    distance > sensor[:di]
  end

  if invisible then
    answer2 = edge[:x] * 4000000 + edge[:y]
    break
  end
end

puts "Answer 2: #{answer2}"