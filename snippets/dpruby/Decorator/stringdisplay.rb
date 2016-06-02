class StringDisplay < Display
  def initialize(str)
    @str = str
  end

  def columns
    @str.length
  end

  def rows
    1
  end

  def row_text(row)
    if row == 0
      return @str
    else
      return nil
    end
  end
end
