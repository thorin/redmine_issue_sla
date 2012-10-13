module RedmineIssueSla
  module Infectors
    module QueriesHelper
      module ClassMethods; end
  
      module InstanceMethods

        def column_value_with_issue_sla(column, issue, value)
          if column.name != :expiration_date || value.class.name != 'Time'
            return column_value_without_issue_sla(column, issue, value) 
          end

          now = Time.now
          if !issue.update_by_manager_date.nil?
            ''
          elsif value.future?
            # distance_of_time_in_words(now, value)
            l('datetime.distance_in_words.x_hours', :count => ((value - now)/1.hour).round(2))
          else
            l(:expiration_satus_overdue)
          end
        end

        def expiration_in_words(issue)
          if issue.update_by_manager_date.present?
            time = distance_of_time_in_words(issue.created_on, issue.update_by_manager_date, true)
            l(:expiration_satus_answered_after_x_time, time)
          elsif issue.expiration_date.future?
            time = distance_of_time_in_words_to_now(issue.expiration_date, true)
            l(:expiration_satus_expires_in_x_time, time)
          else
            time = distance_of_time_in_words_to_now(issue.expiration_date, true)
            l(:expiration_satus_x_time_overdue, time)
          end
        end

      end

      def self.included(receiver)
        receiver.extend         ClassMethods
        receiver.send :include, InstanceMethods
        receiver.class_eval do
          unloadable
          alias_method_chain :column_value, :issue_sla
        end
      end
    end
  end 
end