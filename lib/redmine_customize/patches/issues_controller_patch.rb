require_dependency 'issues_controller'

module RedmineCustomize::Patches::IssuesControllerPatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :build_new_issue_from_params, :public_drafts
  end

  def build_new_issue_from_params_with_public_drafts
    if params[:draft]
      draft_hex_key  = params[:draft]
      draft          = @project.public_drafts.find_by_hex_key!(draft_hex_key)
      params[:issue] = draft.values
    end
    build_new_issue_from_params_without_public_drafts
  end

  private

  # Find a project based on params[:project_id] or params[:draft]
  def find_optional_project
    @project = params[:project_id].blank? ?
      # Try to get project from draft
      find_project_in_draft :
      Project.find(params[:project_id])

    allowed = User.current.allowed_to?(
      { controller: params[:controller], action: params[:action] }, @project, global: true
    )
    allowed ? true : deny_access
  rescue ActiveRecord::RecordNotFound
    render_404
  end

  def find_project_in_draft
    if params[:draft]
      draft = PublicDraft.find_by_hex_key!(params[:draft])
      draft.try(:project)
    end
  end
end
