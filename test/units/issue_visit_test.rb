require File.expand_path('../../test_helper', __FILE__)

class IssueVisitTest < ActiveSupport::TestCase
  fixtures :users, :issues

  def test_new_visit_with_user
    issue = Issue.first
    user = User.first
    visit = IssueVisit.find_or_initialize_by_issue(issue, user)
    assert visit
    refute visit.persisted?
    assert_equal issue, visit.issue
    assert_equal user, visit.user
  end

  def test_new_visit_without_user
    issue = Issue.first
    User.current = User.first
    visit = IssueVisit.find_or_initialize_by_issue(issue)
    assert visit
    refute visit.persisted?
    assert_equal issue, visit.issue
    assert_equal User.current, visit.user
  end

  def test_find_visit_with_user
    issue = Issue.first
    user = User.first
    IssueVisit.create!(:user_id => user.id, :issue_id => issue.id)
    visit = IssueVisit.find_by_issue(issue, user)
    assert visit
    assert visit.persisted?
    assert_equal issue, visit.issue
    assert_equal user, visit.user
  end

  def test_find_visit_without_user
    issue = Issue.first
    User.current = User.first
    user = User.current
    IssueVisit.create!(:user_id => user.id, :issue_id => issue.id)
    visit = IssueVisit.find_by_issue(issue)
    assert visit
    assert visit.persisted?
    assert_equal issue, visit.issue
    assert_equal user, visit.user
  end

end
