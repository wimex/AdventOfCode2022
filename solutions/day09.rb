# frozen_string_literal: true

def simulate(lines, knots)
  visits = []

  lines.each do |s|
    # From every line, take the direction and the number of steps
    dir = s[:d]
    cnt = s[:c]

    (0..cnt - 1).each do |_|
      knots.each_with_index do |_, index|
        # Always move the head based on the direction
        if index == 0 then
          knots[index] = {
            x: if dir == 'R' then knots[index][:x] + 1 elsif dir == 'L' then knots[index][:x] - 1 else knots[index][:x] end,
            y: if dir == 'U' then knots[index][:y] - 1 elsif dir == 'D' then knots[index][:y] + 1 else knots[index][:y] end
          }
        else
          # Calculate the previous knot's distance
          xdist = (knots[index - 1][:x] - knots[index][:x])
          ydist = (knots[index - 1][:y] - knots[index][:y])

          # When one coordinate is further than 2 steps...
          if xdist.abs >= 2 || ydist.abs >= 2 then
            # Move the knot to the direction of the previous knot
            # Move a maimmum of 1 step into the direction (so half if the distance is 2, 1 or 0 otherwise)
            knots[index] = {
              x: xdist.abs == 2 ? knots[index][:x] + xdist / 2 : knots[index][:x] + xdist,
              y: ydist.abs == 2 ? knots[index][:y] + ydist / 2 : knots[index][:y] + ydist
            }
          end
        end
      end

      visits |= [knots.last]
    end
  end

  visits
end

lines = File
          .read('../inputs/day09.txt')
          .split("\n")
          .map { |l| l.split(" ") }
          .map { |l| {d: l[0], c: l[1].to_i}}

visits1 = simulate(lines, Array.new(2, {x: 0, y: 0}))
visits2 = simulate(lines, Array.new(10, { x: 0, y: 0 }))

puts "Answer 1: #{visits1.count}"
puts "Answer 2: #{visits2.count}"
