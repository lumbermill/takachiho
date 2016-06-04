class HtmlWriter
  def initialize(fh)
    @fh = fh
  end

  def title(title)
    @fh.write("<html>")
    @fh.write("<head>")
    @fh.write("<title>"+title+"</title>")
    @fh.write("</head>")
    @fh.write("<body>\n")
    @fh.write("<h1>"+title+"</h1>\n")
  end

  def paragraph(msg)
    @fh.write("<p>"+msg+"</p>\n")
  end

  def link(href,caption)
    paragraph("<a href='#{href}'>#{caption}</a>")
  end

  def mailto(mailaddr,username)
    link("mailto:"+mailaddr, username)
  end

  def close
    @fh.write("</body>")
    @fh.write("</html>\n")
    @fh.close
  end
end
