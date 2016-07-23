class ListTray < Tray
  def initialize(caption)
    super(caption)
  end

  def make_html
    str = "<li>"
    str += caption # + "\n"
    str += "<ul>"
    tray.each do |item|
      str += item.make_html
    end
    str += "</ul></li>"
    return str
  end
end
