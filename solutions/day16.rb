# frozen_string_literal: true

def find_optimal(topography, working, cache, position, open, time, rate, amount)
  total_if_staying = amount + time * rate

  return [amount, open] if time == 0
  return [total_if_staying, open] if open.length == working.length + 1

  candidates = working.filter { |w, _| w != position && !open.include?(w) }
  return [total_if_staying, open + [position]] if candidates.length == 0

  max = { a: amount + time * rate, o: open }
  candidates.each do |candidate, _|
    key = get_cache_key([position, candidate].sort)
    distance = cache[key]
    remaining = time - (distance + 1)
    next if distance.nil?
    next if remaining < 0

    a, o = find_optimal(topography, working, cache, candidate, open + [position], remaining, rate + topography[candidate][:r], amount + rate * (distance + 1))
    max = { a: a, o: o } if a > max[:a]
  end

  [max[:a], max[:o]]
end

def get_distance(topography, from, to, path)
  return path.length if from == to

  minimal = 9999
  topography[from][:p].filter { |p| !path.include?(p) }.each do |p|
    length = get_distance(topography, p, to, path + [from])
    minimal = [minimal, length].min
  end

  minimal
end

def get_cache_key(keys)
  keys.join('_').to_sym
end

valves = []
rates = []

lines = File.read("../inputs/day16.txt").split("\n")
lines.each { |l| rates.push(l.scan /\d+/) }
lines.each { |l| valves.push(l.scan /[A-Z]{2}/) }

topography = {}
valves.zip(rates).each do |valve, rate|
  section = { v: valve[0].to_sym, r: rate[0].to_i, p: valve.drop(1).map { |p| p.to_sym }, d: {} }
  topography[valve[0].to_sym] = section
end

cache = {}
start = 'AA'.to_sym

topography.filter { |_, v| v[:r] > 0 || v[:v] == start }.each do |key1, _|
  topography.filter { |_, v| v[:r] > 0 || v[:v] == start }.each do |key2, _|
    key = get_cache_key([key1, key2].sort)
    next if key1 == key2
    next if cache.include?(key)

    cache[key] = get_distance(topography, key1, key2, [])
  end
end

# File.open("cache.txt", "wb") { |f| Marshal.dump(cache, f) }
# cache = File.open("cache.txt", "rb") { |f| Marshal.load(f) }

working = topography.filter { |_, v| v[:r] > 0 }
answer1, valves1 = find_optimal(topography, working, cache, start, [], 30, 0, 0)

puts "Answer 1: #{answer1}"
puts "Opened valves: "
pp valves1