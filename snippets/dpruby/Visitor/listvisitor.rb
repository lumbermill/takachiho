class ListVisitor
  def initialize
    @currentdir = ""
  end

  def visit_file(f)
    puts @currentdir + "/" + f.name
  end

  def visit_dir(d)
    puts @currentdir + "/" + d.name
    savedir = @currentdir
    @currentdir = @currentdir + "/" + d.name
    d.dir.each do |e|
      e.accept(self)
    end
    @currentdir = savedir
  end
end
