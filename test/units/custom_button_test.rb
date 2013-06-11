require File.expand_path('../../test_helper', __FILE__)

class CustomButtonTest < ActiveSupport::TestCase

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
        :project_id     => 1,
        :tracker_id     => 2,
        :status_id      => 3,
        :category_id    => 4,
        :author_id      => 5,
        :assigned_to_id => 6
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_some_filter
    button = CustomButton.new(
        :status_id      => 3,
        :category_id    => 4,
        :author_id      => 5,
        :assigned_to_id => 6
    )

    assert_true button.visible?(@issue)
  end

  def test_visible_wrong_filter
    button = CustomButton.new(
        :status_id      => 1,
        :category_id    => 2,
        :author_id      => 5,
        :assigned_to_id => 6
    )

    assert_false button.visible?(@issue)
  end

  def test_visible_no_filter
    button = CustomButton.new()

    assert_true button.visible?(@issue)
  end

  def test_filter_hash
    h = {
        :project_id     => 1,
        :tracker_id     => 2,
        :status_id      => 3,
        :category_id    => 4,
        :author_id      => 5,
        :assigned_to_id => 6
    }

    button = CustomButton.new h

    assert_equal h, button.send(:filter_hash)
  end
end
