# frozen_string_literal: true

lines = File.read('../inputs/day01.txt')
chunks = lines
           .split("\n\n")
           .map { |s| s.split("\n") }
           .map { |a| a.map { |s| s.to_i } }

ans1 = chunks
         .map { |a| a.sum }
         .sort
         .reverse

pp "Answer 1: #{ans1[0]}"
pp "Answer 2: #{ans1[0] + ans1[1] + ans1[2]}"