class Context
  def initialize(text)
    @tokens = text.split(" ")
    @position = 0
  end

  def next_token
    @position += 1
    @tokens[@position]
  end

  def current_token
    @tokens[@position]
  end

  def skip_token(token)
    unless token == current_token
      raise "Warning: #{token} is expected, but #{current_token} is found."
    end
    next_token
  end

  def current_number
    Integer(current_token)
  end
end
