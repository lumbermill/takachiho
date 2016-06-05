class StringDisplay
  include Display
  def initialize(string)
    @string = string
  end

  def open
    println
  end

  def print
    puts "|"+@string+"|"
  end

  def close
    println
  end

  private
    def println
      Kernel.print "+"
      @string.length.times do
        Kernel.print "-"
      end
      Kernel.print "+\n"
    end
end
