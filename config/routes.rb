RedmineApp::Application.routes.draw do
  resource :customize, :only => [:show, :update]
  resources :custom_buttons, :only => [
      :index, :new, :create, :edit, :update, :destroy
  ]
  resources :sidebar_blocks, :only => [:update]

  # public drafts
  resources :projects, :only => [] do
    resources :draft_issues, :only => [:create]
  end
  resources :draft_issues, :only => [:show]
end
