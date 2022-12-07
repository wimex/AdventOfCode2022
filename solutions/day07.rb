# frozen_string_literal: true

class ElfNode
  attr_accessor :parent, :name, :size
end

class ElfFile < ElfNode
  def initialize(parent, name, size)
    @parent = parent
    @name = name
    @size = size
  end
end

class ElfDirectory < ElfNode
  attr_accessor :children

  def size
    ds = @children.filter { |c| c.class == ElfDirectory }.map { |c| c.size }.sum
    fs = @children.filter { |c| c.class == ElfFile }.map { |c| c.size }.sum
    ds + ((ds + fs) <= 100000 ? fs : 0)
  end

  def mkfile(name, size)
    @children.push(ElfFile.new(self, name, size))
  end

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

  def cd(name)
    if name == "/"
      @pointer = @tree
    elsif name == ".."
      @pointer = @pointer.parent
    else
      directory = @pointer.children.find { |d| d.name == name }
      throw new Exception("Target directory not found #{name}") if directory.nil?

      @pointer = directory
    end
  end

  def mkdir(name)
    throw new Exception("Target directory already exists: #{name}") unless @pointer.children.find { |d| d.name == name }.nil?
    @pointer.mkdir(name)
  end

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

chunks.each do |c|
  parts = c.split(" ")
  filesystem.send(parts[1], parts[2]) if parts[0] == "$"
  convert_to_command(filesystem, parts) if parts[0] != "$"
end

answer1 = filesystem.size

puts "Answer 1: #{answer1}"