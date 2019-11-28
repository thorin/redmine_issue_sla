# Sample plugin controller
class IssueSlasController < ApplicationController
  unloadable

  before_action :find_project_by_project_id
  before_action :authorize, :only => [:update]

  def update
    params[:issue_sla].each do |priority_id, allowed_delay|
      issue_sla = @project.issue_slas.find_by_priority_id(priority_id)
      if allowed_delay.present?
        issue_sla.allowed_delay = allowed_delay.to_f
      else
        issue_sla.allowed_delay = nil
      end
      issue_sla.save
    end
    
    flash[:notice] = l(:notice_successful_update)
    redirect_to settings_project_path(@project, :tab => 'issue_sla')
  end

end
