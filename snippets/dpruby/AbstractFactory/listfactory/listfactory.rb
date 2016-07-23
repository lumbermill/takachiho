class ListFactory
  def create_link(caption,url)
    return ListLink.new(caption,url)
  end

  def create_tray(caption)
    return ListTray.new(caption)
  end

  def create_page(title,author)
    return ListPage.new(title,author)
  end
end
