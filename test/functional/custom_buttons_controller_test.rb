require File.expand_path('../../test_helper', __FILE__)

class CustomButtonsControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
           :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
           :auth_sources

  def setup
    @controller = CustomButtonsController.new
    @request    = ActionController::TestRequest.new
    @user = User.find(2)
    @request.session[:user_id] = @user.id
    @response   = ActionController::TestResponse.new
    @button = @user.custom_buttons.create(
        :name => 'test_button', :new_values => { :status => 1 } )
  end

  def test_index
    get :index
    assert_response :success
  end

  def test_get_new
    get :new
    assert_response :success
  end

  def test_post_create_with_min_fields
    attrs = {
        :name => 'test_create',
        :new_values => { :status_id => 1, :done_ratio => 100 }
    }
    post :create, :custom_button => attrs
    assert_response :redirect

    btn = @user.custom_buttons.find_by_name(attrs[:name])
    assert btn
    assert_equal attrs[:new_values][:status_id], btn.new_values['status_id'].to_i
    assert_equal attrs[:new_values][:done_ratio], btn.new_values['done_ratio'].to_i
  end

  def test_get_edit
    get :edit, :id => @button.id
    assert_response :success
  end

  def test_put_update
    attrs = {
        :name => 'test_update',
        :new_values => { :status_id => 3, :done_ratio => 50 }
    }

    put :update, :id => @button.id, :custom_button => attrs
    assert_response :redirect

    btn = @user.custom_buttons.find_by_name(attrs[:name])
    assert btn
    assert_equal attrs[:new_values][:status_id], btn.new_values['status_id'].to_i
    assert_equal attrs[:new_values][:done_ratio], btn.new_values['done_ratio'].to_i
  end

  def test_post_destroy
    post :destroy, :id => @button.id
    assert_response :redirect
    btn = @user.custom_buttons.find_by_name(@button.name)
    assert_nil btn
  end

  def test_move_higher
    @user.custom_buttons.create(
        :name => 'test_button2', :new_values => { :status => 2 } )
    b1 = CustomButton.by_position[0]
    b2 = CustomButton.by_position[1]

    assert_equal 1, b1.position
    assert_equal 2, b2.position

    put :update, :id => b2.id, :custom_button => { 'move_to' => 'higher' }

    assert_response :redirect

    b1.reload
    b2.reload

    assert_equal 2, b1.position
    assert_equal 1, b2.position
  end

  def test_move_lower
    @user.custom_buttons.create(
        :name => 'test_button2', :new_values => { :status => 2 } )
    b1 = CustomButton.by_position[0]
    b2 = CustomButton.by_position[1]

    assert_equal 1, b1.position
    assert_equal 2, b2.position

    put :update, :id => b1.id, :custom_button => { 'move_to' => 'lower' }

    assert_response :redirect

    b1.reload
    b2.reload

    assert_equal 2, b1.position
    assert_equal 1, b2.position
  end

end
