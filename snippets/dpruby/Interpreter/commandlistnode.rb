class CommandListNode
  def initialize
    @list = []
  end

  def parse(context)
    while true
      if context.current_token.nil?
        raise ParseError.new('Missing "end"')
      elsif context.current_token == "end"
        context.skip_token("end")
        break
      else
        command_node = CommandNode.new
        command_node.parse(context)
        @list += [command_node]
      end
    end
  end

  def to_s
    "["+@list.join(", ")+"]"
  end
end
