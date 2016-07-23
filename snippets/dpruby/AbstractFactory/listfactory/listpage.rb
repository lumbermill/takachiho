class ListPage < Page
  def initialize(title,author)
    super(title,author)
  end

  def make_html
    str = "<html><head><title>#{@title}</title></head>\n"
    str += "<body>\n"
    str += "<h1>#{@title}</h1>\n"
    str += "<ul>\n"
    @content.each do |item|
      str += item.make_html
    end
    str += "</ul>\n"
    str += "<hr><address>#{@author}</address>"
    str += "</body></html>"
    return str
  end
end
