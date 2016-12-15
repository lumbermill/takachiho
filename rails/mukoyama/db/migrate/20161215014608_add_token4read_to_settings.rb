class AddToken4readToSettings < ActiveRecord::Migration
  def change
    remove_index "settings", column: "token", name: "index_settings_on_token"
    rename_column :settings, :token, :token4write
    add_column :settings, :token4read, :string, limit:255
  end
end
