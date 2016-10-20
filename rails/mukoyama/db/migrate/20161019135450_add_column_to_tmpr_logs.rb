class AddColumnToTmprLogs < ActiveRecord::Migration
  def change
    add_column :tmpr_logs, :sender, :string
  end
end
