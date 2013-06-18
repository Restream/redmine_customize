class CustomButtonsController < ApplicationController
  before_filter :require_login
  before_filter :get_user
  before_filter :watch_is_public, :only => [:create, :update]

  helper :custom_fields

  def index
    @custom_buttons = @user.custom_buttons
  end

  def new
    @custom_button = @user.custom_buttons.build
    get_collections_for_select
  end

  def create
    @custom_button = @user.custom_buttons.new(params[:custom_button])
    if @custom_button.save
      flash[:notice] = l(:text_custom_button_created)
      redirect_to custom_buttons_path
    else
      get_collections_for_select
      render :action => 'new'
    end
  end

  def edit
    @custom_button = @user.custom_buttons.find(params[:id])
    get_collections_for_select
  end

  def update
    @custom_button = @user.custom_buttons.find(params[:id])
    if @custom_button.update_attributes(params[:custom_button])
      flash[:notice] = l(:text_custom_button_updated)
      redirect_to custom_buttons_path
    else
      get_collections_for_select
      render :action => 'edit'
    end
  end

  def destroy
    @custom_button = @user.custom_buttons.find(params[:id])
    @custom_button.destroy
    flash[:notice] = l(:text_custom_button_destroyed)
    redirect_to custom_buttons_path
  end

  private

  def get_user
    @user = User.current
  end

  def get_collections_for_select
    @projects = Project.where(Project.allowed_to_condition(@user, :edit_issues))
    @trackers = Tracker.sorted
    @statuses = IssueStatus.sorted
    @categories = IssueCategory.includes(:project).
        order('projects.name, issue_categories.name')
    @users = User.active.order(User.fields_for_order_statement)
  end

  def watch_is_public
    params[:custom_button].delete(:is_public) unless @user.admin?
    true
  end

end
