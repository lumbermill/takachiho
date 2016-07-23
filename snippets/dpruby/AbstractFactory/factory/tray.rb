class Tray
  attr_reader :tray, :caption

  def initialize(caption)
    @tray = []
    @caption = caption
  end

  def add(item)
    @tray += [item]
  end
end
