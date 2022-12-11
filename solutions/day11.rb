# frozen_string_literal: true

# Convert the operation string to an operator and a value
def apply_operation(item, operand, value)
  # The right value is the provided integer or the current value in case of old
  right = if value == 'old' then item else value.to_i end

  # Call the method by the operand name and pass the right side
  item.method(operand).(right)
end

# Take a monkey and inspect an item
def inspect_item(monkey, items, dividers, relaxer)
  # Whenever the monkey inspects an item, we select the current operation and the index of the current divider
  operation = monkey[:operation]
  index = dividers.find_index(monkey[:test])

  # We keep track of multiple levels: to every divider we are interested in belongs a different value
  # Apply the operation to all values and simplify them to the remainder if possible
  # The simplification is possible only when it's not divided by 3 (2nd answer)
  levels = items.map { |i| apply_operation(i, operation[:o], operation[:v]) / relaxer }
  remainders = levels.each_with_index.map { |l, i| l.floor % dividers[i] }
  returned = if relaxer == 1 then remainders else levels end

  # Throw the item to the monkey based on the result
  return [returned, monkey[:next][:t]] if remainders[index] == 0
  return [returned, monkey[:next][:f]] unless remainders[index] == 0
end

# Run the entire simulation
def monkey_business(part)
  # The number of rounds...
  (0..part[:rounds] - 1).each do |_|
    # Go through each monkey...
    part[:monkeys].each do |monkey|
      monkey[:items].each do |item|
        # Inspect each item and throw it to the next monkey
        worries, target = inspect_item(monkey, item, part[:dividers], part[:relaxer])
        part[:monkeys][target][:items].push(worries)

        # This monkey has inspected an item
        monkey[:inspects] += 1
      end

      # All items have been inspected and thrown so now this monkey has nothing
      monkey[:items] = []
    end
  end
end

def get_monkeys(chunks, monkeys, dividers)
  chunks.map do |g|
    lines = g.split("\n")
    next if lines.nil?

    # Make sure we considered every possibility
    raise "Error" unless lines[0].start_with?("Monkey")
    raise "Error" unless lines[1].start_with?("  Starting items")
    raise "Error" unless lines[2].start_with?("  Operation: new = old ")
    raise "Error" unless lines[3].start_with?("  Test: divisible by")
    raise "Error" unless lines[4].start_with?("    If true: throw to monkey")
    raise "Error" unless lines[5].start_with?("    If false: throw to monkey")

    items = lines[1].split(": ")[1].split(", ").map { |i| i.to_i }
    operation = lines[2].split("new = ")[1].split(" ")
    divider = lines[3].split("by ")[1].to_i
    raise "Error" unless operation.length == 3

    dividers.push(divider)
    monkeys.push({
                   items: items.map { |i| Array.new(chunks.length, i) },
                   test: divider,
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
end

part1 = {
  monkeys: [],
  dividers: [],
  rounds: 20,
  relaxer: 3
}

part2 = {
  monkeys: [],
  dividers: [],
  rounds: 10000,
  relaxer: 1
}

chunks = File.read('../inputs/day11.txt').split("\n\n")
get_monkeys(chunks, part1[:monkeys], part1[:dividers])
get_monkeys(chunks, part2[:monkeys], part2[:dividers])

monkey_business(part1)
monkey_business(part2)

answer1 = part1[:monkeys].sort_by { |a| a[:inspects] }.reverse
answer2 = part2[:monkeys].sort_by { |a| a[:inspects] }.reverse

puts "Answer 1: #{answer1[0][:inspects] * answer1[1][:inspects]}"
puts "Answer 2: #{answer2[0][:inspects] * answer2[1][:inspects]}"