class MyFile < Entry
  def initialize(name,size)
    @name = name
    @size = size
  end

  def print_list_impl(prefix)
    puts prefix+"/"+self.to_s
  end
end
