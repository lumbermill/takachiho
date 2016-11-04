class AddColumnToAddresses < ActiveRecord::Migration
  def change
    add_column :addresses, :snooze, :integer, {null: false, default: 60}
  end
end
