require 'singleton'

class BigCharFactory
  include Singleton
  def initialize
    @pool = {}
  end

  def bigchar(ch)
    bc = @pool[ch]
    if bc.nil?
      bc = BigChar.new(ch)
      @pool[ch] = bc
    end
    return bc
  end
end
