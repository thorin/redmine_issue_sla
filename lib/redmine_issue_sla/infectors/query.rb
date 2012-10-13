module RedmineIssueSla
  module Infectors
    module Query
      module ClassMethods; end
  
      module InstanceMethods

          def available_filters_with_issue_sla
            return @available_filters if @available_filters
            available_filters_without_issue_sla
            
            @available_filters["expiration_date"] = { :name => l("field_expiration_date") , :type => :date, :order => 5.5}
            @available_filters
          end

      end

      def self.included(receiver)
        receiver.extend(ClassMethods)
        receiver.send(:include, InstanceMethods)
        receiver.class_eval do
          unloadable
          
          alias_method_chain :available_filters, :issue_sla
        end
      end
      
    end
  end
end