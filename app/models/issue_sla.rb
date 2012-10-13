class IssueSla < ActiveRecord::Base
  belongs_to :project, :class_name => 'Project', :foreign_key => 'project_id'
  belongs_to :priority, :class_name => 'IssuePriority', :foreign_key => 'priority_id'

  validates_presence_of :priority, :project
  validates_numericality_of :allowed_delay, :allow_nil => true
  
  attr_protected :priority_id, :project_id
  
  before_save :update_issues
  
  private
  def update_issues
    project.issues.open.where(:priority_id => priority.id).all.each do |issue|
      next if issue.update_by_manager_date.present?
      
      date = nil
      if allowed_delay.present?
        date = allowed_delay.hours.since issue.created_on
      end
      issue.update_attributes(:expiration_date => date) if issue.expiration_date != date
    end
  end
end
