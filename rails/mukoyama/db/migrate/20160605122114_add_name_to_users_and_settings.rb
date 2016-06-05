class AddNameToUsersAndSettings < ActiveRecord::Migration
  def change
    add_column :users, :name, :string
    add_column :settings, :name, :string
  end
end
