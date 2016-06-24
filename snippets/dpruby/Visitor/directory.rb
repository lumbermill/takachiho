class Directory < Entry
  def initialize(name)
    @name = name
    @dir = []
  end

  def size
    s = 0
    @dir.each do |e|
      s += e.size
    end
    return s
  end

  def add(e)
    @dir += [e]
    return self
  end

  def print_list_impl(prefix)
    puts prefix+"/"+self.to_s
    @dir.each do |e|
      e.print_list_impl(prefix+"/"+@name)
    end
  end

  # Added for visitor pattern
  attr_reader :name, :dir

  def accept(v)
    v.visit_dir(self)
  end
end
