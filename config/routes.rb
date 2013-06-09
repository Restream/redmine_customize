RedmineApp::Application.routes.draw do
  resource :customize, :only => [:show, :update]
  resources :custom_buttons, :only => [
      :index, :new, :create, :edit, :update, :destroy
  ]
end
