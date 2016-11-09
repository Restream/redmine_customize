class DraftIssuesController < ApplicationController
  before_filter :find_project, only: [:create]

  def create
    draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, params[:issue])
    render text: draft_issue_url(draft.hex_key, only_path: false), status: :ok, layout: nil
  rescue RedmineCustomize::Services::DraftSaveError
    render nothing: true, status: :error, layout: nil
  end

  def show
    redirect_to RedmineCustomize::Services::Drafts.new_issue_urlc(params[:id])
  end

  private

  def find_project
    project_id = params[:project_id] || (params[:issue] && params[:issue][:project_id])
    @project   = Project.find(project_id)
  rescue ActiveRecord::RecordNotFound
    render_404
  end
end
