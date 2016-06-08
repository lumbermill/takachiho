class BookShelfIterator
  def initialize(bookshelf)
    @bookshelf = bookshelf
    @index = 0
  end

  def has_next
    if @index < @bookshelf.length
      return true
    else
      return false
    end
  end

  def next
    book = @bookshelf.book_at(@index)
    @index += 1
    return book
  end
end
