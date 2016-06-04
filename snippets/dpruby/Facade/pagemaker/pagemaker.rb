require_relative './database.rb'
require_relative './htmlwriter.rb'

class PageMaker
  def self.make_welcome_page(mailaddr,filename)
    mailprop = Database.properties("maildata")
    username = mailprop[mailaddr]
    writer = HtmlWriter.new(open(filename,"w"))
    writer.title("Welcome to #{username}'s page!")
    writer.paragraph("Hello. I am #{username}.")
    writer.paragraph("I am waiting for the message from you.")
    writer.mailto(mailaddr, username)
    writer.close
    puts "#{filename} is created for #{mailaddr} (#{username})."
  end
end
