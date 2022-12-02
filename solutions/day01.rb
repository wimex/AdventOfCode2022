# frozen_string_literals

lines = File.read('../inputs/day01.txt')
chunks = lines
           .split("\n\n")
           .map { |s| s.split("\n") }
           .map { |a| a.map { |s| s.to_i } }

ans1 = chunks
         .map { |a| a.sum }
         .max

pp "Answer 1: #{ans1}"