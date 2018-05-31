class AddGoogledriveToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :google_drive_url, :string
  end
end
