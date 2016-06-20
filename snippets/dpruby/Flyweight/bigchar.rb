class BigChar
  attr_reader :fontdata
  def initialize(ch)
    @ch = ch
    @fontdata = open("big#{ch}.txt").readlines.map { |line| line.strip }
  end
end
