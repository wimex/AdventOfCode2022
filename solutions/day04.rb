# frozen_string_literal: true

lines = File.read('../inputs/day04.txt')
chunks = lines
           .split("\n")
           .map { |l| l.split(",") }
           .map { |s| { a: s[0].split("-"), b: s[1].split("-") } }
           .map { |s| {
             a: { l: s[:a][0], r: s[:a][1] },
             b: { l: s[:b][0], r: s[:b][1] }
           } }

answer1 = chunks
            .select { |c| (c[:a][:l] <= c[:b][:l] && c[:a][:r] >= c[:b][:r]) || (c[:b][:l] <= c[:a][:l] && c[:b][:r] >= c[:a][:r]) }
            .count

puts "Answer 1: #{answer1}"