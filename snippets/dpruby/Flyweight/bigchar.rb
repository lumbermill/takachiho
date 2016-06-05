class BigChar
  def initialize(ch)
    @ch = ch
    @fontdata = open("big#{ch}.txt").read
  end

  def print
    puts @fontdata
  end
end
