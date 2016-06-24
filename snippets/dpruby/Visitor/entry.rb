class Entry
  attr_reader :size
  def add(e)
    raise "Can not treat."
  end

  def print_list
    print_list_impl("")
  end

  def to_s
    "#{@name} (#{self.size})"
  end
end
