class HTMLBuilder
  def make_title(title)
    @filename = title+".html"
    @writer = open(@filename,"w")
    @writer.write("<html><head><title>#{title}</title></head><body>\n")
    @writer.write("<h1>#{title}</h1>")
  end

  def make_string(str)
    @writer.write("<p>#{str}</p>")
  end

  def make_items(items)
    @writer.write("<ul>")
    items.each do |i|
      @writer.write("<li>#{i}</li>")
    end
    @writer.write("</ul>")
  end

  def close
    @writer.write("</body></html>")
    @writer.close
  end

  def get_result
    @filename
  end
end
