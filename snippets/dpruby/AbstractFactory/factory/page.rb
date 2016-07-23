class Page
  def initialize(title,author)
    @content = []
    @title = title
    @author = author
  end

  def add(item)
    @content += [item]
  end

  def output
    filename = @title+".html"
    fh = open(filename,"w")
    fh.write(make_html)
    fh.close
    puts "#{filename} was created."
  end

  def make_html
    raise 'notimplemented yet'
  end
end
