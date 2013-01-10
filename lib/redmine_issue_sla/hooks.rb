module RedmineIssueSla
  class Hooks < Redmine::Hook::ViewListener
    def controller_issues_new_before_save(context)
      save_expiration_date(context[:issue])
    end
    
    def controller_issues_edit_before_save(context)
      save_expiration_date(context[:issue])
    end

    def save_expiration_date(issue, user = User.current)
      if issue.new_record? && user.allowed_to?(:add_issues, issue.project)
        sla = issue.issue_sla
        if sla && sla.allowed_delay.present?
          attrs = { :expiration_date => sla.allowed_delay.hours.from_now }
          issue.assign_attributes attrs, :without_protection => true
        end
      end
      if user.allowed_to?(:be_project_manager, issue.project) && !issue.update_by_manager_date
        attrs = { :update_by_manager_date => Time.at(Time.now.to_i) }
        issue.assign_attributes attrs, :without_protection => true
        issue.attributes_before_change['update_by_manager_date'] = issue.update_by_manager_date if issue.attributes_before_change
        Rails.logger.debug("Attrs - #{issue.attributes_before_change}")
      end
    end
    
  end
  
  class ViewHooks < Redmine::Hook::ViewListener
    render_on :view_issues_show_details_bottom, :partial => "issues/show_expiration"
  end
end