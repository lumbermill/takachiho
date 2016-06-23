require_relative './manager.rb'

class UnderlinePen
  def initialize(ch)
    @ch = ch
  end

  def use(s)
    puts '"'+s+'"'
    print ' '
    print @ch * s.length
    puts ' '
  end
end
