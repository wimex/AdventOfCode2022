# frozen_string_literal: true
require 'matrix'

# Create a matrix from the input
lines = File
          .read('../inputs/day09.txt')
          .split("\n")
          .map { |l| l.split(" ") }
          .map { |l| {d: l[0], c: l[1].to_i}}

visits = []
head = { x: 0, y: 0 }
memo = { x: 0, y: 0 }
tail = { x: 0, y: 0 }

lines.each do |s|
  dir = s[:d]
  cnt = s[:c]

  (0..cnt - 1).each do |_|
    visits |= [tail]
    xdist = (head[:x] - tail[:x]).abs
    ydist = (head[:y] - tail[:y]).abs

    tail = memo if xdist >= 2 || ydist >= 2
    memo = head

    head = {
      x: if dir == 'R' then head[:x] + 1 elsif dir == 'L' then head[:x] - 1 else head[:x] end,
      y: if dir == 'U' then head[:y] - 1 elsif dir == 'D' then head[:y] + 1 else head[:y] end
    }
  end
end

answer1 = visits.count

puts "Answer 1: #{answer1}"
