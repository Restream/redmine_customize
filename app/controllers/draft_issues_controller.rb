class DraftIssuesController < ApplicationController
  respond_to :json, :only => [:create]

  before_filter :find_project, :only => [:create]

  def create
    draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, params[:issue])
    render :json => { :hex_key => draft.hex_key }, :status => :ok, :layout => nil
  rescue RedmineCustomize::Services::DraftSaveError
    render :json => {}, :status => :error, :layout => nil
  end

  private

  def find_project
    project_id = params[:project_id] || (params[:issue] && params[:issue][:project_id])
    @project = Project.find(project_id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
