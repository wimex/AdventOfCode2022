# frozen_string_literal: true

points = %w[a b c d e f g h i j k l m n o p q r s t u v w x y z A B C D E F G H I J K L M N O P Q R S T U V W X Y Z]

lines = File.read('../inputs/day03.txt')
chunks = lines
           .split("\n")
           .map { |s| s.partition(/.{#{s.size / 2}}/)[1, 2] }
           .map { |c| (c[0].chars & c[1].chars).join}
           .map { |c| points.index(c) + 1}

puts "Answer 1: #{chunks.sum}"
