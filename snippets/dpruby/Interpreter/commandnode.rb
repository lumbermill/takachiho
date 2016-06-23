class CommandNode
  def parse(context)
    if context.current_token == "repeat"
      @node = RepeatCommandNode.new
      @node.parse(context)
    else
      @node = PrimitiveCommandNode.new
      @node.parse(context)
    end
  end

  def to_s
    @node.to_s
  end
end
