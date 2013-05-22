RedmineApp::Application.routes.draw do
  resource :customize, :only => [:show, :update]
end
