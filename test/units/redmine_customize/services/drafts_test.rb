require File.expand_path('../../../../test_helper', __FILE__)

class RedmineCustomize::Services::DraftsTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
    :issues, :members, :roles, :member_roles, :enumerations,
    :enabled_modules, :journals, :journal_details

  def setup
    @project = Project.find(1)
    @values  = { subject: 'test' }
  end

  def test_create_public_draft
    public_draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, @values)
    assert public_draft
    assert_equal @values, public_draft.values
  end

  def test_attempt_to_save_non_unique_hex_key_will_raise_error
    RedmineCustomize::Services::Drafts.stubs(:generate_hex_key).returns('0')
    public_draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, @values)
    assert public_draft
    assert_raise RedmineCustomize::Services::DraftSaveError do
      RedmineCustomize::Services::Drafts.create_public_draft(@project, @values)
    end
  end

  def test_url_for_return_right_url
    public_draft = RedmineCustomize::Services::Drafts.create_public_draft(@project, @values)
    url          = RedmineCustomize::Services::Drafts.new_issue_urlc(public_draft.hex_key)
    expected_url = "/projects/ecookbook/issues/new?draft=#{public_draft.hex_key}"
    assert_equal expected_url, url
  end
end
