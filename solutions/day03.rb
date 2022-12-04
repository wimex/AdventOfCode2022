# frozen_string_literal: true

points = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]

lines = File.read('../inputs/day03.txt')
chunks = lines.split("\n")

# Split strings into half, get common string and index into points
answer1 = chunks
            .map { |s| s.partition(/.{#{s.size / 2}}/)[1, 2] }
            .map { |c| (c[0].chars & c[1].chars).join }
            .map { |c| points.index(c) + 1 }
            .sum

# Take every three line, get common string and index into points
answer2 = chunks
            .each_slice(3)
            .map { |c| (c[0].chars & c[1].chars & c[2].chars).join }
            .map { |c| points.index(c) + 1 }
            .sum

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2}"
