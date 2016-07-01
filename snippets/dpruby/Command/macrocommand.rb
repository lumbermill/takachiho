class MacroCommand
  def initialize
    @commands = []
  end

  def execute
    @commands.each do |c|
      c.execute
    end
  end

  def append(c)
    @commands += [c]
  end

  def undo
    @commands.pop
  end

  def clear
    @commands = []
  end
end
    