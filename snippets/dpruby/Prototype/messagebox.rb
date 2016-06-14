require_relative './manager.rb'

class MessageBox
  def initialize(ch)
    @ch = ch
  end

  def use(s)
    print @ch * (s.length+4) + "\n"
    puts "#{@ch} #{s} #{@ch}"
    print @ch * (s.length+4) + "\n"
  end
end
