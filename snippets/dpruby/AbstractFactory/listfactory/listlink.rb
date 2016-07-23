class ListLink < Link
  def initialize(caption, url)
    super(caption,url)
  end

  def make_html
    "  <li><a href='#{@url}'>#{@caption}</a></li>"
  end
end
