# frozen_string_literal

table = [
  [{ s: 'A Y', p: 2 }, { s: 'B Z', p: 3 }, { s: 'C X', p: 1 }],
  [{ s: 'A X', p: 1 }, { s: 'B Y', p: 2 }, { s: 'C Z', p: 3 }],
  [{ s: 'A Z', p: 3 }, { s: 'B X', p: 1 }, { s: 'C Y', p: 2 }]
]

lines = File.read('../inputs/day02.txt')
chunks = lines
           .split("\n")

results1 = chunks.map { |c|
  w = table[0].filter { |t| t[:s] === c}.first&.dig(:p) || 0
  d = table[1].filter { |t| t[:s] === c}.first&.dig(:p) || 0
  l = table[2].filter { |t| t[:s] === c}.first&.dig(:p) || 0

  if w > 0 then
    w + 6
  elsif d > 0
    d + 3
  else
    l
  end
}

pp "Answer 1: #{results1.sum}"