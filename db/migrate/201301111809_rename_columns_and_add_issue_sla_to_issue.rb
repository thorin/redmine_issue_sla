class RenameColumnsAndAddIssueSlaToIssue < ActiveRecord::Migration[5.1]
  def self.up
    add_column :issues, :issue_sla, :float
    rename_column :issues, :update_by_manager_date, :first_response_date

    Issue.where("expiration_date is not null").each do |i| 
    	i.update_attributes(:issue_sla => (i.expiration_date - i.created_on)/3600)
    end
  end

  def self.down
    remove_column :issues, :issue_sla
    rename_column :issues, :first_response_date, :update_by_manager_date
  end
end
