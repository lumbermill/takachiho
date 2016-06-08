class BookShelf
  def initialize(maxsize)
    @books = Array.new(maxsize)
    @last = 0
  end

  def book_at(index)
    @books[index]
  end

  def append_book(book)
    @books[@last] = book
    @last += 1
  end

  def length
    @last
  end

  def iterator
    BookShelfIterator.new(self)
  end
end
