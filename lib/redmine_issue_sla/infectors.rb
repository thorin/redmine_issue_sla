module RedmineIssueSla
  module Infectors
    Dir[File.join(File.dirname(__FILE__), "infectors", "*.rb")].each{|file| 
      require_dependency file;
      infected_name = File.basename(file, ".rb").classify
      Rails.logger.info "Infected #{infected_name} with #{file}"
      _module = RedmineIssueSla::Infectors.const_get(infected_name)
      _class = Kernel.const_get(infected_name)
      _class.send(:include, _module) unless _class.included_modules.include? _module
    }
  end
end