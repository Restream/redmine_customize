require File.expand_path('../../test_helper', __FILE__)

class CustomButtonTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users

  def setup
    @issue = Issue.new(
        :project_id     => 1,
        :tracker_id     => 2,
        :status_id      => 3,
        :category_id    => 4,
        :author_id      => 5,
        :assigned_to_id => 6
    )
  end

  def test_visible_all_filter
    button = CustomButton.new(
        :project_ids     => '1',
        :tracker_ids     => '2',
        :status_ids      => '3',
        :category_ids    => '4',
        :author_ids      => '5',
        :assigned_to_ids => '6'
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_some_filter
    button = CustomButton.new(
        :status_ids      => '1,3',
        :category_ids    => '4',
        :author_ids      => '5',
        :assigned_to_ids => '6'
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_wrong_filter
    button = CustomButton.new(
        :status_ids      => '1',
        :category_ids    => '2',
        :author_ids      => '5',
        :assigned_to_ids => '6'
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
        :project_ids     => '1,2',
        :tracker_ids     => '2,3',
        :status_ids      => '1,3',
        :category_ids    => '2,3',
        :author_ids      => '1,2',
        :assigned_to_ids => '3,4'
    )
    assert_equal [1, 2], button.filters[:project_id]
    assert_equal [2, 3], button.filters[:tracker_id]
    assert_equal [1, 3], button.filters[:status_id]
    assert_equal [2, 3], button.filters[:category_id]
    assert_equal [1, 2], button.filters[:author_id]
    assert_equal [3, 4], button.filters[:assigned_to_id]
  end

  def test_filter_getter
    button = CustomButton.new()
    button.filters = {
        :project_id     => [1, 2],
        :tracker_id     => [2, 3],
        :status_id      => [1, 3],
        :category_id    => [2, 3],
        :author_id      => [1, 2],
        :assigned_to_id => [3, 4]
    }
    assert_equal '1,2', button.project_ids
    assert_equal '2,3', button.tracker_ids
    assert_equal '1,3', button.status_ids
    assert_equal '2,3', button.category_ids
    assert_equal '1,2', button.author_ids
    assert_equal '3,4', button.assigned_to_ids
  end

  def test_filter_collections
    button = CustomButton.new(
        :project_ids     => '1,2',
        :tracker_ids     => '2,3',
        :status_ids      => '1,3',
        :category_ids    => '2,3',
        :author_ids      => '1,2',
        :assigned_to_ids => '3,4'
    )
    assert_equal [1, 2], button.projects.map(&:id)
    assert_equal [2, 3], button.trackers.map(&:id)
    assert_equal [1, 3], button.statuses.map(&:id)
    assert_equal [2, 3], button.categories.map(&:id)
    assert_equal [1, 2], button.authors.map(&:id)
    assert_equal [3, 4], button.assigned_tos.map(&:id)
  end

  def test_clear_filter
    button = CustomButton.new(:project_ids => '1,2')
    button.project_ids = ''
    assert_equal [], button.filters[:project_id]
    button.project_ids = nil
    assert_equal [], button.filters[:project_id]
  end

end
