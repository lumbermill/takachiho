class CharDisplay
  include Display
  def initialize(ch)
    @ch = ch
  end

  def open
    Kernel.print "<<"
  end

  def print
    Kernel.print @ch
  end

  def close
    Kernel.print ">>\n"
  end
end
