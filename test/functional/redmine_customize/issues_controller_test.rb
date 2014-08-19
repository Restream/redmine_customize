require File.expand_path('../../../test_helper', __FILE__)

class RedmineCustomize::IssuesControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources, :projects_trackers, :enabled_modules

  def setup
    @controller = IssuesController.new
    @request    = ActionController::TestRequest.new
    @user = User.find(2)
    @request.session[:user_id] = @user.id
    @project = Project.find(1)
  end

  def test_draft_values_were_applied_to_new_issue
    issue_attrs = { :subject => 'draft_subject' }
    draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, issue_attrs)
    get :new, :project_id => @project.identifier, :draft => draft.hex_key
    assert_response :success
    assert_tag :tag => 'input',
               :attributes => { :id => 'issue_subject', :value => 'draft_subject' }
  end

  def test_issue_visit_saved
    issue = Issue.visible(@user).first
    assert issue
    get :show, :id => issue.id
    visit = IssueVisit.find_by_issue(issue, @user)
    assert visit
    assert_equal 1, visit.visit_count
  end

  def test_issue_visit_count
    issue = Issue.visible(@user).first
    assert issue
    5.times { get :show, :id => issue.id }
    visit = IssueVisit.find_by_issue(issue, @user)
    assert visit
    assert_equal 5, visit.visit_count
  end

  def test_issue_visit_time
    issue = Issue.visible(@user).first
    assert issue
    get :show, :id => issue.id
    after_first_visit = Time.now
    sleep 1
    get :show, :id => issue.id
    sleep 1
    after_last_visit = Time.now
    visit = IssueVisit.find_by_issue(issue, @user)
    assert visit
    assert visit.last_visit.between?(after_first_visit, after_last_visit)
  end
end
