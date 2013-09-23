require File.expand_path('../../test_helper', __FILE__)

class CustomButtonTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
           :issues, :members, :roles, :member_roles, :enumerations,
           :enabled_modules, :journals, :journal_details

  def setup
    @user = User.find(2)
    User.current = @user
    @issue = Issue.find(2)
    @issue.category_id = 2
    @issue.save!
      #id: 2
      #project_id: 1
      #tracker_id: 2
      #status_id: 2
      #category_id: 2
      #author_id: 2
      #assigned_to_id: 3 (role: 2)
  end

  def test_visible_all_filter
    button = CustomButton.new(
        :project_ids       => '1',
        :tracker_ids       => '2',
        :status_ids        => '2',
        :category_ids      => '2',
        :author_ids        => '2',
        :assigned_to_ids   => '3',
        :assigned_to_role_ids => '2'
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_some_filter
    button = CustomButton.new(
        :status_ids      => '2,3',
        :category_ids    => '2',
        :author_ids      => '2',
        :assigned_to_ids => '3'
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_wrong_filter
    button = CustomButton.new(
        :status_ids      => '1,3',
        :category_ids    => '2',
        :author_ids      => '2',
        :assigned_to_ids => '3'
    )

    assert_false button.visible?(@issue)
  end

  def test_visible_no_filter
    button = CustomButton.new()

    assert_true button.visible?(@issue)
  end

  def test_public_button
    admin = User.find(1)
    button = admin.custom_buttons.build(
        :is_public => 1
    )

    assert_true button.is_public?
  end

  def test_private_button_by_default
    button = CustomButton.new()

    assert_false button.is_public?
  end

  def test_filter_setter
    button = CustomButton.new(
        :project_ids       => '1,2',
        :tracker_ids       => '2,3',
        :status_ids        => '1,3',
        :category_ids      => '2,3',
        :author_ids        => '1,2',
        :assigned_to_ids   => '3,4',
        :assigned_to_role_ids => '1,2'
    )
    assert_equal ['1', '2'], button.filters[:project_id]
    assert_equal ['2', '3'], button.filters[:tracker_id]
    assert_equal ['1', '3'], button.filters[:status_id]
    assert_equal ['2', '3'], button.filters[:category_id]
    assert_equal ['1', '2'], button.filters[:author_id]
    assert_equal ['3', '4'], button.filters[:assigned_to_id]
    assert_equal ['1', '2'], button.filters[:assigned_to_role_id]
  end

  def test_filter_getter
    button = CustomButton.new()
    button.filters = {
        :project_id       => [1, 2],
        :tracker_id       => [2, 3],
        :status_id        => [1, 3],
        :category_id      => [2, 3],
        :author_id        => [1, 2],
        :assigned_to_id   => [3, 4],
        :assigned_to_role_id => [1, 2]
    }
    assert_equal '1,2', button.project_ids
    assert_equal '2,3', button.tracker_ids
    assert_equal '1,3', button.status_ids
    assert_equal '2,3', button.category_ids
    assert_equal '1,2', button.author_ids
    assert_equal '3,4', button.assigned_to_ids
    assert_equal '1,2', button.assigned_to_role_ids
  end

  def test_filter_collections
    button = CustomButton.new(
        :project_ids       => '1,2',
        :tracker_ids       => '2,3',
        :status_ids        => '1,3',
        :category_ids      => '2,3',
        :author_ids        => '1,2',
        :assigned_to_ids   => '3,4',
        :assigned_to_role_ids => '1,2'
    )
    assert_equal [1, 2], button.projects.map(&:id)
    assert_equal [2, 3], button.trackers.map(&:id)
    assert_equal [1, 3], button.statuses.map(&:id)
    assert_equal [2, 3], button.categories.map(&:id)
    assert_equal [1, 2], button.authors.map(&:id)
    assert_equal [3, 4], button.assigned_tos.map(&:id)
    assert_equal [1, 2], button.assigned_to_roles.map(&:id)
  end

  def test_clear_filter
    button = CustomButton.new(:project_ids => '1,2')
    button.project_ids = ''
    assert_equal [], button.filters[:project_id]
    button.project_ids = nil
    assert_equal [], button.filters[:project_id]
  end

  def test_show_for_issue__when_has_changes
    button = CustomButton.new(
        :hide_when_nothing_change => '1',
        :new_values => { :status_id => 3 }
    )
    assert_true button.send(:show_for_issue?, @issue)
  end

  def test_show_for_issue__when_has_no_changes
    button = CustomButton.new(
        :hide_when_nothing_change => '1',
        :new_values => { :status_id => 2 }
    )
    assert_false button.send(:show_for_issue?, @issue)
  end

  def test_show_for_issue__if_assigned_to_changed
    # assigned_to_id == 3 && author_id == 2
    button = CustomButton.new(
        :hide_when_nothing_change => '1',
        :new_values => { :assigned_to_id => 'author' }
    )
    assert_true button.send(:show_for_issue?, @issue)
  end

  def test_show_for_issue__if_assigned_to_not_changed
    # assigned_to_id == 3 && author_id == 3
    @issue.stubs(:author).returns User.find(3)
    @issue.stubs(:author_id).returns 3
    button = CustomButton.new(
        :hide_when_nothing_change => '1',
        :new_values => { :assigned_to_id => 'author' }
    )
    assert_false button.send(:show_for_issue?, @issue)
  end

end
