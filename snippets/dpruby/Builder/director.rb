class Director
  def initialize(builder)
    @builder = builder
  end

  def construct
    @builder.make_title("Greeting")
    @builder.make_string("From the morning to the afternoon")
    @builder.make_items(["Good morning.","Good afternoon."])
    @builder.make_string("At night")
    @builder.make_items(["Good evening.","Good night.","Good bye."])
    @builder.close
  end
end
