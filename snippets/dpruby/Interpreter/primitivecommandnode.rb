class PrimitiveCommandNode
  def parse(context)
    @name = context.current_token
    context.skip_token(@name)
    if @name != "go" && @name != "right" && @name != "left"
      raise @name + " is undefined"
    end
  end

  def to_s
    @name
  end
end
