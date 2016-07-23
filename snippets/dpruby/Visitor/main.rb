# Copied from Compsite pattern.
require_relative './entry.rb'
require_relative './directory.rb'
require_relative './file.rb'

require_relative './listvisitor.rb'

puts "Making root entries.."
rootdir = Directory.new("root")
bindir = Directory.new("bin")
tmpdir = Directory.new("tmp")
homedir = Directory.new("home")
rootdir.add(bindir)
rootdir.add(tmpdir)
rootdir.add(homedir)
bindir.add(MyFile.new("vi",10000))
bindir.add(MyFile.new("latex",20000))
rootdir.accept(ListVisitor.new)

puts ""
puts "Making user entries.."
alice = Directory.new("alice")
bob = Directory.new("bob")
chris = Directory.new("chris")
homedir.add(alice)
homedir.add(bob)
homedir.add(chris)
alice.add(MyFile.new("a.txt",100))
alice.add(MyFile.new("b.txt",200))
bob.add(MyFile.new("c.txt",300))
chris.add(MyFile.new("d.txt",400))
chris.add(MyFile.new("e.txt",500))
rootdir.accept(ListVisitor.new)
