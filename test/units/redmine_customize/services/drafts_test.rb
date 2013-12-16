require File.expand_path('../../../../test_helper', __FILE__)

class RedmineCustomize::Services::DraftsTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
           :issues, :members, :roles, :member_roles, :enumerations,
           :enabled_modules, :journals, :journal_details

  def test_create_public_draft
    project = Project.find(1)
    values = { :subject => 'test' }
    public_draft = RedmineCustomize::Services::Drafts.create_public_draft(project, values)
    assert public_draft
    assert_equal values, public_draft.values
  end
end
