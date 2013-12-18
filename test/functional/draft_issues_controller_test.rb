require File.expand_path('../../test_helper', __FILE__)

class DraftIssuesControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources

  def setup
    @controller = DraftIssuesController.new
    @request    = ActionController::TestRequest.new
    @user = User.find(2)
    @request.session[:user_id] = @user.id
    @project = Project.find(1)
    @issue_attrs = { :subject => 'draft' }
  end

  def test_create_draft
    xhr :post, :create, :project_id => @project.identifier, :issue => @issue_attrs
    assert_response :success
    draft = PublicDraft.order(:id).last
    assert draft
    exp_url = draft_issue_url(draft.hex_key)
    assert_equal exp_url, response.body
  end

  def test_save_error
    RedmineCustomize::Services::Drafts.stubs(:generate_hex_key).returns('0')
    RedmineCustomize::Services::Drafts.create_public_draft(@project, @issue_attrs)
    xhr :post, :create, :project_id => @project.identifier, :issue => @issue_attrs
    assert_response :error
  end

  def test_redirected_to_new_issue
    draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, @issue_attrs)
    get :show, :id => draft.hex_key
    assert_redirected_to new_project_issue_url(@project.identifier, :draft => draft.hex_key)
  end
end
