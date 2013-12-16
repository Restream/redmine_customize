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
  end

  def test_create_draft
    project = Project.find(1)
    issue_attrs = { :subject => 'draft' }
    xhr :post, :create, :project_id => project.identifier, :issue => issue_attrs
    assert_response :success
  end

  def test_save_error
    project = Project.find(1)
    issue_attrs = { :subject => 'draft' }
    RedmineCustomize::Services::Drafts.stubs(:generate_hex_key).returns('0')
    RedmineCustomize::Services::Drafts.create_public_draft(project, issue_attrs)
    xhr :post, :create, :project_id => project.identifier, :issue => issue_attrs
    assert_response :error
  end
end
