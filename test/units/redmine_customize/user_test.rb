require File.expand_path('../../../test_helper', __FILE__)

class RedmineCustomize::UserTest < ActiveSupport::TestCase
  fixtures :users

  def setup
    @user = User.find(2)
    @issue = Issue.new(
        :project_id     => 1,
        :tracker_id     => 2,
        :status_id      => 3,
        :category_id    => 4,
        :author_id      => 5,
        :assigned_to_id => 6
    )
    @user.custom_buttons.create(
        :name => 'button1',
        :new_values => { 'project_id' => 2 }
    )
    @user.custom_buttons.create(
        :name => 'button2',
        :project_ids => '1',
        :new_values => { 'project_id' => 2 }
    )
    @user.custom_buttons.create(
        :name => 'button3',
        :project_ids => '2',
        :new_values => { 'project_id' => 2 }
    )
    @user.custom_buttons.create(
        :name => 'button4',
        :project_ids => '1,2',
        :category_ids => '4',
        :new_values => { 'project_id' => 2 }
    )
  end

  def test_visible_custom_buttons
    button_names = @user.visible_custom_buttons(@issue).map(&:name).sort
    assert_equal %w[button1 button2 button4], button_names
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
    button_names = @user.visible_custom_buttons(@issue).map(&:name).sort
    assert_equal %w[button1 button2 button4 button6], button_names
  end

end
