class TableTray < Tray
  def initialize(caption)
    super(caption)
  end

  def make_html
    str = "<td>"
    str += "<table width='100%'' border='1'><tr>"
    str += "<td bgcolor='#ccc' align='center' colspan='#{@tray.size}'><b>#{@caption}</b></td>"
    str += "</tr>"
    str += "<tr>"
    @tray.each do |item|
      str += item.make_html
    end
    str += "</tr></table>"
    str += "</td>"
    return str
  end
end
