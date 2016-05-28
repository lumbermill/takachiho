class TextBuilder
  def make_title(title)
    @buffer = "==============================\n"
    @buffer << "# " << title << " #\n"
  end

  def make_string(str)
    @buffer << "* #{str}\n"
    @buffer << "\n"
  end

  def make_items(items)
    items.each do |i|
      @buffer << "  - #{i}\n"
    end
    @buffer << "\n"
  end

  def close
    @buffer << "==============================\n"
  end

  def get_result
    @buffer
  end
end

# Rubyの文字列連結
# http://qiita.com/Kta-M/items/c7c2fb0b61b11d3a2c48
