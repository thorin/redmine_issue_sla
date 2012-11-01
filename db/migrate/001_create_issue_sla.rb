class CreateIssueSla < ActiveRecord::Migration
  def self.up
    create_table :issue_slas, :force => true do |t|
      t.integer :project_id, :null => false
      t.integer :priority_id, :null => false
      t.float :allowed_delay
    end
    
    add_column :issues, :expiration_date, :datetime
    add_column :issues, :update_by_manager_date, :datetime
  end

  def self.down
    drop_table :issue_sla
    
    remove_column :issues, :expiration_date
    remove_column :issues, :update_by_manager_date
  end
end
