class PrinterProxy
  attr_reader :name
  def initialize(name)
    @name = name
  end

  def name=(name)
    real.name = name unless @real.nil?
    @name = name
  end

  def print(str)
    realize
    @real.print(str)
  end

  def realize
    if @real.nil?
      @real = Printer.new(@name)
    end
  end
end
