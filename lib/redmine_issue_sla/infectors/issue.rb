module RedmineIssueSla
  module Infectors
    module Issue
      module ClassMethods; end

      module InstanceMethods
        attr_accessor :attributes_before_change

        def priority_issue_sla
          priority.issue_slas.where(:project_id => project_id).first
        end
      end

      def self.included(receiver)
        receiver.extend(ClassMethods)
        receiver.send(:include, InstanceMethods)
        receiver.class_eval do
          unloadable
        end
      end
    end
  end
end