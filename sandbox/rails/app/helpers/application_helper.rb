module ApplicationHelper
  def list_group_item(head,body,path)
    text = '<p class="list-group-item-heading">'+head+'</p>'
    text += '<p class="list-group-item-text text-muted">'+body+'</p>'
    link_to text.html_safe, path, class: "list-group-item"
  end
end
