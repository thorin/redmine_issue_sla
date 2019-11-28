class IssueSla < ActiveRecord::Base
  belongs_to :project, :class_name => 'Project', :foreign_key => 'project_id'
  belongs_to :priority, :class_name => 'IssuePriority', :foreign_key => 'priority_id'

  validates_presence_of :priority, :project
  validates_numericality_of :allowed_delay, :allow_nil => true

  #attr_protected :priority_id, :project_id

  before_save :update_issues

  private
  def update_issues
    project.issues.open.where(:priority_id => priority.id).all.each do |issue|
      next if issue.first_response_date.present?

      date = nil
      if allowed_delay.present?
        date = allowed_delay.hours.since(issue.created_on).round
      end
      if issue.expiration_date != date
        issue.init_journal(User.current)
        issue.current_journal.attributes_before_change['expiration_date'] = date
        issue.update_attributes(:expiration_date => date, :issue_sla => allowed_delay)
      end
    end
  end
end
