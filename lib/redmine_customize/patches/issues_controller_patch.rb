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
end
