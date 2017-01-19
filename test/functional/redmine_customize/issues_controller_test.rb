require File.expand_path('../../../test_helper', __FILE__)

class RedmineCustomize::IssuesControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
    :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
    :auth_sources, :projects_trackers, :enabled_modules

  def setup
    @controller                = IssuesController.new
    @request                   = ActionController::TestRequest.new
    @user                      = User.find(2)
    @request.session[:user_id] = @user.id
    @project                   = Project.find(1)
  end

  def test_draft_values_were_applied_to_new_issue
    issue_attrs = { subject: 'draft_subject' }
    draft       = RedmineCustomize::Services::Drafts.create_public_draft(@project, issue_attrs)
    get :new, project_id: @project.identifier, draft: draft.hex_key
    assert_response :success
    assert_select "input#issue_subject:match('value', ?)", 'draft_subject'
  end

  def test_draft_values_were_applied_to_new_issue_without_project
    issue_attrs = { subject: 'draft_subject' }
    draft       = RedmineCustomize::Services::Drafts.create_public_draft(@project, issue_attrs)
    get :new, draft: draft.hex_key
    assert_response :success
    assert_select "input#issue_subject:match('value', ?)", 'draft_subject'
  end

  def test_issues_new_without_project_and_draft
    get :new
    assert_response :success
  end

  def test_show_issue_without_errors
    get :show, id: 1
    assert_response :success
  end
end
