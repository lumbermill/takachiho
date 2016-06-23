class RepeatCommandNode
  def parse(context)
    context.skip_token("repeat")
    @number = context.current_number
    context.next_token
    @command_list_node = CommandListNode.new
    @command_list_node.parse(context)
  end

  def to_s
    "[repeat #{@number} #{@command_list_node}]"
  end
end
