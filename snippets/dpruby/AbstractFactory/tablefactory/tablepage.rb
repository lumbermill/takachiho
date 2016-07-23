class TablePage < Page
  def initialize(title,author)
    super(title,author)
  end

  def make_html
    str = "<html><head><title>#{@title}</title></head>\n"
    str += "<body>"
    str += "<h1>#{@title}</h1>"
    str += "<table width='80%' border='3'>"
    @content.each do |item|
      str += "<tr>"+item.make_html+"</tr>"
    end
    str += "</table>"
    str += "<hr><address>#{@author}</address>"
    str += "</body></html>"
    return str
  end
end
