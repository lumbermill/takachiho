class MyFile < Entry
  def initialize(name,size)
    @name = name
    @size = size
  end

  def print_list_impl(prefix)
    puts prefix+"/"+self.to_s
  end

  # Added for visitor pattern
  attr_reader :name

  def accept(v)
    v.visit_file(self)
  end
end
