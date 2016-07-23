class Tray
  def initialize(caption)
    @tray = []
    @caption = caption
  end

  def add(item)
    @tray += [item]
  end
end
