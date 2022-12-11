# frozen_string_literal: true

def apply_operation(item, operand, value)
  right = if value == 'old' then item else value.to_i end
  item.method(operand).(right)
end

def inspect_item(monkey, item)
  operation = monkey[:operation]
  worry_a = apply_operation(item, operation[:o], operation[:v])
  worry_b = (worry_a / 3).floor

  test = worry_b % monkey[:test]
  return [worry_b, monkey[:next][:t]] if test == 0
  return [worry_b, monkey[:next][:f]] unless test == 0

  raise "Error"
end

monkeys = []
rounds = 20

chunks = File.read('../inputs/day11.txt').split("\n\n")
chunks.map do |g|
  lines = g.split("\n")
  next if lines.nil?

  raise "Error" unless lines[0].start_with?("Monkey")
  raise "Error" unless lines[1].start_with?("  Starting items")
  raise "Error" unless lines[2].start_with?("  Operation: new = old ")
  raise "Error" unless lines[3].start_with?("  Test: divisible by")
  raise "Error" unless lines[4].start_with?("    If true: throw to monkey")
  raise "Error" unless lines[5].start_with?("    If false: throw to monkey")

  operation = lines[2].split("new = ")[1].split(" ")
  raise "Error" unless operation.length == 3

  monkeys.push({
                 items: lines[1].split(": ")[1].split(", ").map { |i| i.to_i },
                 test: lines[3].split("by ")[1].to_i,
                 inspects: 0,
                 operation: {
                   o: operation[1],
                   v: operation[2]
                 },
                 next: {
                   t: lines[4].split("monkey ")[1].to_i,
                   f: lines[5].split("monkey ")[1].to_i
                 }
               })
end

(0..rounds - 1).each do |_|
  monkeys.each do |monkey|
    monkey[:items].each do |item|
      worry, target = inspect_item(monkey, item)
      monkeys[target][:items].push(worry)

      monkey[:inspects] += 1
    end

    # All items have been inspected and thrown
    monkey[:items] = []
  end
end

answer1 = monkeys.sort_by { |a| a[:inspects] }.reverse
puts "Answer 1: #{answer1[0][:inspects] * answer1[1][:inspects]}"