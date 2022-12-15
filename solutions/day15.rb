# frozen_string_literal: true

sensors = []
beacons = []

lines = File.read("../inputs/day15.txt")
            .split("\n")
            .map { |l| l.scan /-?\d+/ }
            .map { |l| l.map { |d| d.to_i } }

lines.each do |l|
  sensors.push({ x: l[0], y: l[1] })
  beacons.push({ x: l[2], y: l[3] })
end



answer1 = 0
y = 2000000
-1000000.step(to: 9000000, by: 1).each do |x|
    sensors.zip(beacons) do |sensor, beacon|
      beacon_distance = (beacon[:x] - sensor[:x]).abs + (beacon[:y] - sensor[:y]).abs
      point_distance = (x - sensor[:x]).abs + (y - sensor[:y]).abs

      if point_distance <= beacon_distance && !(x == beacon[:x] && y == beacon[:y]) then
        answer1 += 1
        break
      end
    end
end


puts "Answer 1: #{answer1}"