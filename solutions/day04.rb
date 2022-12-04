# frozen_string_literal: true

lines = File.read('../inputs/day04.txt')
chunks = lines
           .split("\n")
           .map { |l| l.split(",") }
           .map { |s| { a: s[0].split("-"), b: s[1].split("-") } }
           .map { |s| { l: (s[:a][0].to_i..s[:a][1].to_i), r: (s[:b][0].to_i..s[:b][1].to_i) } }

# Check if range A contains range B or range B contains range A
answer1 = chunks
            .select { |c| (c[:l].first <= c[:r].first && c[:l].last >= c[:r].last) || (c[:r].first <= c[:l].first && c[:r].last >= c[:l].last) }
            .count

# Check if range A starts before range B ends or range A ends before range B starts
answer2 = chunks
            .select { |c| c[:l].first <= c[:r].last && c[:r].first <= c[:l].last }
            .count

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2}"