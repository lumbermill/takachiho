class TableFactory
  def create_link(caption,url)
    return TableLink.new(caption,url)
  end

  def create_tray(caption)
    return TableTray.new(caption)
  end

  def create_page(title,author)
    return TablePage.new(title,author)
  end
end
