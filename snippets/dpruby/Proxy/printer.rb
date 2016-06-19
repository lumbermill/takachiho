class Printer
  attr_accessor :name
  def initialize(name)
    @name = name
    heavy_job("Creating Printer instance(for #{name}).")
  end

  def print(str)
    puts "=== #{name} ==="
    puts str
  end

  def heavy_job(msg)
    Kernel.print msg
    5.times do
      sleep 1
      Kernel.print "."
    end
    puts "Fin."
  end
end
