# frozen_string_literal: true

table = [
  [{ s: 'A Y', p: 2 }, { s: 'B Z', p: 3 }, { s: 'C X', p: 1 }], # win
  [{ s: 'A X', p: 1 }, { s: 'B Y', p: 2 }, { s: 'C Z', p: 3 }], # draw
  [{ s: 'A Z', p: 3 }, { s: 'B X', p: 1 }, { s: 'C Y', p: 2 }]  # lose
]

desired = %w[Z Y X] # for part 2: win, draw, lose

lines = File.read('../inputs/day02.txt')
chunks = lines
           .split("\n")

# Take every element, check if it's in the winning or the loosing table
# Modify points based on outcome
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

# Check the desired result, select the option from the table
# Modify points based on outcome
results2 = chunks.map { |c|
  idx = desired.index(c[2])
  res = table[idx].filter { |t| t[:s][0] === c[0] }.first

  if idx == 0
    res[:p] + 6
  elsif idx == 1
    res[:p] + 3
  else
    res[:p]
  end
}

pp "Answer 1: #{results1.sum}"
pp "Answer 2: #{results2.sum}"

