require_relative './book.rb'
require_relative './bookshelf.rb'
require_relative './bookshelfiterator.rb'

bookshelf = BookShelf.new(4)
bookshelf.append_book(Book.new("A Wild Sheel Chase"))
bookshelf.append_book(Book.new("Dance Dance Dance"))
bookshelf.append_book(Book.new("The Wind-Up Bird Chronicle"))
it = bookshelf.iterator
while it.has_next do
  book = it.next
  puts book.name
end
