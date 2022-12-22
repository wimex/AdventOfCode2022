# frozen_string_literal: true

# Go through the graph and find every possible route to open the valves
def find_optimal(topography, working, cache, position, open, time, rate, amount, routes)
  amount_if_staying = amount + time * rate

  # Save the amount released on the current route if it's bigger than previously
  if open.length > 0 then
    route_key = open.sort.join('_').to_sym
    routes[route_key] = amount_if_staying if routes[route_key].nil? || amount_if_staying > routes[route_key]
  end

  # Return if there is no more time or no valves left to open
  return [amount, open] if time == 0
  return [amount_if_staying, open] if open.length == working.length + 1

  if topography[position][:r] > 0 && time >= 1 && !open.include?(position) then
    # Open the valve, increase the rate and add 1 minute to the time
    find_optimal(topography, working, cache, position, open + [position], time - 1, rate + topography[position][:r], amount + rate, routes)
  else
    # Walk all the possible valves to open from the current spot
    candidates = working.filter { |w, _| w != position && !open.include?(w) }
    return [amount_if_staying, open] if candidates.length == 0

    max = { a: amount_if_staying, o: open }
    candidates.each do |candidate, _|
      key = get_cache_key([position, candidate].sort)
      distance = cache[key]
      remaining = time - distance
      next if distance.nil?
      next if remaining <= 0

      # The rate stays the same but the time lowers when we travel to another valve
      a, o = find_optimal(topography, working, cache, candidate, open, remaining, rate, amount + rate * distance, routes)
      max = { a: a, o: o } if a > max[:a]
    end

    # Return the biggest amount of pressure that can be released
    [max[:a], max[:o]]
  end
end

# Precalculate the distance from every valve to every other valve
def get_distance(topography, from, to, path)
  return path.length if from == to

  minimal = 9999
  topography[from][:p].filter { |p| !path.include?(p) }.each do |p|
    length = get_distance(topography, p, to, path + [from])
    minimal = [minimal, length].min
  end

  minimal
end

# Create a key for the cache - this could be simplified by ordering the keys so XX -> YY is the same as YY -> XX
def get_cache_key(keys)
  keys.join('_').to_sym
end

valves = []
rates = []

lines = File.read("../inputs/day16.txt").split("\n")
lines.each { |l| rates.push(l.scan /\d+/) }
lines.each { |l| valves.push(l.scan /[A-Z]{2}/) }

# Combine the data together
topography = {}
valves.zip(rates).each do |valve, rate|
  section = { v: valve[0].to_sym, r: rate[0].to_i, p: valve.drop(1).map { |p| p.to_sym }, d: {} }
  topography[valve[0].to_sym] = section
end

cache = {}
start = 'AA'.to_sym

# Calculate distances
topography.filter { |_, v| v[:r] > 0 || v[:v] == start }.each do |key1, _|
  topography.filter { |_, v| v[:r] > 0 || v[:v] == start }.each do |key2, _|
    key = get_cache_key([key1, key2].sort)
    next if key1 == key2
    next if cache.include?(key)

    cache[key] = get_distance(topography, key1, key2, [])
  end
end

# Collect all the valves that actually release pressure
working = topography.filter { |_, v| v[:r] > 0 }

# In the first case, we don't care about the possible routes
answer1, valves1 = find_optimal(topography, working, cache, start, [], 30, 0, 0, { })
puts "Answer 1: #{answer1}"
puts "Opened valves: "
pp valves1

routes = {}
_, valves2 = find_optimal(topography, working, cache, start, [], 26, 0, 0, routes)

# Find the two routes releasing the biggest amount of pressure
# This could be simplified to simply ordering them and finding the first two non-crossing paths
answer2 = 0
routes.keys.combination(2) do |combination|
  r1 = combination[0].to_s.split('_')
  r2 = combination[1].to_s.split('_')
  next if (r1 & r2).length > 0 # If the two paths have common valves, don't use them

  val = routes[combination[0]] + routes[combination[1]]
  answer2 = val if val > answer2
end

puts "Answer 2: #{answer2}"
puts "Opened valves: "
pp valves2