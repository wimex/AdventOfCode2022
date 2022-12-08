# frozen_string_literal: true

class ElfNode
  attr_accessor :parent, :name, :size
end

class ElfFile < ElfNode
  def flatten_directories(output)
    output
  end

  def initialize(parent, name, size)
    @parent = parent
    @name = name
    @size = size
  end
end

class ElfDirectory < ElfNode
  attr_accessor :children

  # Recurse into every directory and push it into a flat array
  def flatten_directories(output)
    @children.each do |c|
      c.flatten_directories(output)
    end

    output.push(self)
  end

  def size
    @children.map { |c| c.size }.sum
  end

  # Create a file with the provided name and size in the current directory
  def mkfile(name, size)
    @children.push(ElfFile.new(self, name, size))
  end

  # Create a directory with the provided name in the current directory
  def mkdir(name)
    @children.push(ElfDirectory.new(self, name))
  end

  def initialize(parent, name)
    @parent = parent
    @name = name
    @children = []
  end
end

class ElfFS
  attr_accessor :tree, :pointer

  def size
    @tree.size
  end

  # Change directory
  def cd(name)
    if name == "/"
      @pointer = @tree # Go to the root
    elsif name == ".."
      @pointer = @pointer.parent # Go to the parent
    else
      directory = @pointer.children.find { |d| d.name == name }
      throw new Exception("Target directory not found #{name}") if directory.nil?

      # Go to the selected directory
      @pointer = directory
    end
  end

  # Create a new directory
  def mkdir(name)
    throw new Exception("Target directory already exists: #{name}") unless @pointer.children.find { |d| d.name == name }.nil?
    @pointer.mkdir(name)
  end

  # Create a new file
  def mkfile(name, size)
    throw new Exception("Target directory already exists: #{name}") unless @pointer.children.find { |d| d.name == name }.nil?
    @pointer.mkfile(name, size)
  end

  def ls(_)
    # Do nothing when listing items for now
  end

  def initialize
    @tree = ElfDirectory.new(nil, "")
    @pointer = tree
  end
end

# Convert console output (lines that don't start with $) to a command
def convert_to_command(fs, parts)
  if parts[0] == 'dir'
    fs.send('mkdir', parts[1])
  else
    fs.send('mkfile', parts[1], parts[0].to_i)
  end
end

lines = File.read('../inputs/day07.txt')
chunks = lines.split("\n")

filesystem = ElfFS.new

# Execute commands and map output lines
chunks.each do |c|
  parts = c.split(" ")
  filesystem.send(parts[1], parts[2]) if parts[0] == "$"
  convert_to_command(filesystem, parts) if parts[0] != "$"
end

directories = []
filesystem.tree.flatten_directories(directories)

disk_size = 70000000
required_size = 30000000
used_size = filesystem.size
free_size = disk_size - used_size
missing_size = required_size - free_size

answer1 = directories.filter { |d| d.size <= 100000 }.map { |d| d.size }.sum
answer2 = directories.filter { |d| d.size >= missing_size }.sort { |d| d.size }.map { |d| d.size }.sort.first

puts "Answer 1: #{answer1}"
puts "Answer 2: #{answer2}"