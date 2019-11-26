module RedmineIssueSla
  module Infectors
    module IssueQuery
      module ClassMethods; end

      #module InstanceMethods

          def available_filters
            return @available_filters if @available_filters
            super

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

          def available_columns
            return @available_columns if @available_columns
            super

            if User.current.allowed_to?(:view_issue_sla, project, :global => true)
              @available_columns.push QueryColumn.new(:expiration_date,
                :sortable => ["#{::Issue.table_name}.expiration_date"],
                :groupable => false
              )
            end

            @available_columns
          end

      #end

      #def self.included(receiver)
      #  receiver.extend(ClassMethods)
      #  receiver.send(:include, InstanceMethods)
      #  receiver.class_eval do
      #    unloadable

      #    alias_method_chain :available_filters, :issue_sla
      #    alias_method_chain :available_columns, :issue_sla
      #  end
      #end

    end
  end
end

Issue.prepend RedmineIssueSla::Infectors::IssueQuery
