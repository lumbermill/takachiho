class AddCustomMessagesToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :custom_msg_over, :string
    add_column :devices, :custom_msg_under, :string
  end
end
