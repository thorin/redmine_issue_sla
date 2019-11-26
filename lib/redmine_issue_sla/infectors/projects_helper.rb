module RedmineIssueSla
  module Infectors
    module ProjectsHelper
      module ClassMethods; end

      module InstanceMethods
        def project_settings_tabs_with_issue_sla
          tabs = project_settings_tabs_without_issue_sla
          return tabs unless @project.module_enabled?('redmine_issue_sla')

          if User.current.allowed_to?(:manage_issue_sla, @project)
            tabs << {:name => 'issue_sla', :action  => :manage_issue_sla, :partial => 'projects/settings/issue_sla', :label => :label_issue_sla}
          end
          tabs
        end

        def _retrieve_slas(project)
          slas = project.issue_slas
          ::IssuePriority.all.each do |p|
            next if slas.any? {|s| s.priority_id == p.id }
            sla = IssueSla.create(:priority => p, :project=> project)
          end
          project.issue_slas.reload
        end
      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          unloadable
          #alias_method_chain :project_settings_tabs, :issue_sla
          alias_method :project_settings_tabs_without_issue_sla, :project_settings_tabs
          alias_method :project_settings_tabs, :project_settings_tabs_with_issue_sla          
          alias_method :retrieve_slas, :_retrieve_slas
        end
      end
    end
  end
end

#ProjectsHelper.prepend RedmineIssueSla::Infectors::ProjectsHelper
