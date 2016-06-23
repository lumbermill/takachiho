class ProgramNode
  def parse(context)
    context.skip_token("program")
    @command_list_node = CommandListNode.new
    @command_list_node.parse(context)
  end

  def to_s
    "[program #{@command_list_node}]"
  end
end
