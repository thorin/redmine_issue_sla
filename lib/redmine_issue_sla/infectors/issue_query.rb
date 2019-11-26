module RedmineIssueSla
  module Infectors
    module IssueQuery
      module ClassMethods; end

      module InstanceMethods

          def available_filters_with_issue_sla
            return @available_filters if @available_filters
            available_filters_without_issue_sla

            if User.current.allowed_to?(:view_issue_sla, project, :global => true)
              field = "expiration_date"
              options = {
                  type: :date,
                  order: 5.5,
                  name: l("field_expiration_date")
              }
              @available_filters[field] = QueryFilter.new(field, options)
            end

            @available_filters
          end

          def available_columns_with_issue_sla
            return @available_columns if @available_columns
            available_columns_without_issue_sla

            if User.current.allowed_to?(:view_issue_sla, project, :global => true)
              @available_columns.push QueryColumn.new(:expiration_date,
                :sortable => ["#{::Issue.table_name}.expiration_date"],
                :groupable => false
              )
            end

            @available_columns
          end

      end

      def self.included(receiver)
        receiver.extend(ClassMethods)
        receiver.send(:include, InstanceMethods)
        receiver.class_eval do
          unloadable

          #alias_method_chain :available_filters, :issue_sla
          #alias_method_chain :available_columns, :issue_sla
          alias_method :available_filters_without_issue_sla, :available_filters
          alias_method :available_filters, :available_filters_with_issue_sla
          
          alias_method :available_columns_without_issue_sla, :available_columns
          alias_method :available_columns, :available_columns_with_issue_sla          
        end
      end

    end
  end
end

#Issue.prepend RedmineIssueSla::Infectors::IssueQuery
