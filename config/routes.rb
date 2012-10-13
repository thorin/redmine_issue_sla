RedmineApp::Application.routes.draw do
  put '/projects/:project_id/issue_slas' => 'issue_slas#update'
end