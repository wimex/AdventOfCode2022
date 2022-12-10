# frozen_string_literal: true
require 'matrix'

def addx(state, parameters)
  var = parameters[0].to_i
  state[:register] += var
end

def noop(_, _)
  # Do nothing happily
end

instructions = {
  noop: {f: method(:noop), c: 1},
  addx: {f: method(:addx), c: 2}
}

state = {
  register: 1,
  cycles: 0,
  strength: 0
}

breakpoints = [20, 60, 100, 140, 180, 220]

screen = Array.new(6) { Array.new(40) { "." } }
sprite = [-1, 0, 1]
beam = 0

lines = File.read('../inputs/day10.txt').split("\n")
lines.each do |l|
  instruction, *parameters = l.split(" ")
  method_call = instructions[instruction.to_sym]
  throw new Error if method_call.nil?

  overlay = sprite.map { |s| s + state[:register] }
  (0..method_call[:c] - 1).each do |_|
    visible = overlay.include?(beam % screen[0].length)
    state[:cycles] += 1

    screen_x = beam % screen[0].length
    screen_y = beam / screen[0].length
    screen[screen_y][screen_x] = "#" if visible
    beam += 1

    next unless breakpoints.include?(state[:cycles])
    state[:strength] += state[:cycles] * state[:register]
  end

  callback = method_call[:f]
  callback.call(state, parameters)
end

puts "Answer 1: #{state[:strength]}"
puts "Answer 2:"
screen.each do |line|
  puts line.join(" ")
end