class DrawCommand
  SIZE = 1

  def initialize(canvas,point)
    @canvas = canvas
    @point = point
  end

  def execute
    x = @point[0]
    y = @point[1]
    TkcRectangle.new(@canvas, x - SIZE, y - SIZE, x + SIZE, y + SIZE,outline: nil,fill: 'blue')
  end
end
  