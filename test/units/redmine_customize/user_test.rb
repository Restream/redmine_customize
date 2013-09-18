require File.expand_path('../../../test_helper', __FILE__)

class RedmineCustomize::UserTest < ActiveSupport::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources

  def setup
    @user = User.find(2)
    @issue1 = Issue.find(1)
      #  project_id: 1
      #  priority_id: 4
      #  category_id: 1
      #  tracker_id: 1
      #  assigned_to_id:
      #  author_id: 2
      #  status_id: 1

    @issue4 = Issue.find(4)
      #  project_id: 2
      #  priority_id: 4
      #  category_id:
      #  tracker_id: 1
      #  assigned_to_id: 2
      #  author_id: 2
      #  status_id: 1

    @user.custom_buttons.create(
        :name => 'button1',
        :new_values => { 'project_id' => 3 }
    )
    @user.custom_buttons.create(
        :name => 'button2',
        :project_ids => '1',
        :new_values => { 'project_id' => 3 }
    )
    @user.custom_buttons.create(
        :name => 'button3',
        :project_ids => '2',
        :new_values => { 'project_id' => 3 }
    )
    @user.custom_buttons.create(
        :name => 'button4',
        :project_ids => '1,2',
        :new_values => { 'project_id' => 3 }
    )
    @user.custom_buttons.create(
        :name => 'button5',
        :project_ids => '1,2',
        :assigned_to_ids => '2',
        :new_values => { 'project_id' => 3 }
    )
  end

  def test_visible_public_button
    admin = User.find(1)
    admin.custom_buttons.create(
        :name => 'button5',
        :new_values => { 'project_id' => 2 }
    )
    admin.custom_buttons.create(
        :name => 'button6',
        :new_values => { 'project_id' => 2 },
        :is_public => true
    )
    button_names = @user.visible_custom_buttons(@issue1).map(&:name).sort
    assert_equal %w[button1 button2 button4 button6], button_names
  end

  def test_buttons_visible_for_each_issue
    button_names = @user.visible_custom_buttons(@issue1).map(&:name).sort
    assert_equal %w[button1 button2 button4], button_names

    button_names = @user.visible_custom_buttons(@issue4).map(&:name).sort
    assert_equal %w[button1 button3 button4 button5], button_names

    button_names = @user.visible_custom_buttons([@issue1, @issue4]).map(&:name).sort
    assert_equal %w[button1 button4], button_names
  end

  def test_no_buttons_on_empty_issues
    button_names = @user.visible_custom_buttons([]).map(&:name).sort
    assert_empty button_names
  end

end
