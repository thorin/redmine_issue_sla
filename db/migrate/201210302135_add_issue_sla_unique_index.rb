class AddIssueSlaUniqueIndex < ActiveRecord::Migration
  def self.up
    add_index :issue_slas, [:project_id, :priority_id], :unique => true
  end

  def self.down
    drop_index :issue_slas, [:project_id, :priority_id]
  end
end
