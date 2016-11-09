require File.expand_path('../../test_helper', __FILE__)

class SidebarBlocksControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
    :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
    :auth_sources

  def setup
    @controller                = SidebarBlocksController.new
    @request                   = ActionController::TestRequest.new
    @user                      = User.find(2)
    @request.session[:user_id] = @user.id
    User.current               = @user
    @response                  = ActionController::TestResponse.new
  end

  def test_update_collapsed_blocks
    xhr :put, 'update', id: 'Issues', block: { is_collapsed: 'true' }
    assert_response :success

    xhr :put, 'update', id: 'My custom queries', block: { is_collapsed: 'true' }
    assert_response :success

    collapsed_sidebar_blocks = @user.preference.collapsed_sidebar_blocks
    assert_equal ['Issues', 'My custom queries'], collapsed_sidebar_blocks

    xhr :put, 'update', id: 'Issues', block: { is_collapsed: 'false' }
    assert_response :success

    @user.preference.reload
    collapsed_sidebar_blocks = @user.preference.collapsed_sidebar_blocks
    assert_equal ['My custom queries'], collapsed_sidebar_blocks
  end

end
