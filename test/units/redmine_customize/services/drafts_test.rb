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

  def test_attempt_to_save_non_unique_hex_key_will_raise_error
    RedmineCustomize::Services::Drafts.stubs(:generate_hex_key).returns('0')
    project = Project.find(1)
    values = { :subject => 'test' }
    public_draft = RedmineCustomize::Services::Drafts.create_public_draft(project, values)
    assert public_draft
    assert_raise RedmineCustomize::Services::DraftSaveError do
      RedmineCustomize::Services::Drafts.create_public_draft(project, values)
    end
  end
end
