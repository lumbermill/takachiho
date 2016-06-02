require_relative './border.rb'

class SideBorder < Border
  def initialize(display, ch)
    super(display)
    @ch = ch
  end

  def columns
    1 + @display.columns + 1
  end

  def rows
    @display.rows
  end

  def row_text(row)
    @ch + @display.row_text(row) + @ch
  end
end
