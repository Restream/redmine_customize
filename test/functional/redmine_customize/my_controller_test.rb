require File.expand_path('../../../test_helper', __FILE__)
require 'my_controller'

class RedmineCustomize::MyControllerTest < ActionController::TestCase
  fixtures :users, :user_preferences, :roles, :projects, :members, :member_roles,
    :issues, :issue_statuses, :trackers, :enumerations, :custom_fields,
    :auth_sources

  def setup
    @controller                = MyController.new
    @request                   = ActionController::TestRequest.new
    @request.session[:user_id] = 2
    @response                  = ActionController::TestResponse.new
  end

  def test_account
    get :account
    assert_response :success
    assert_select "a:match('href', ?)", /custom_buttons/
    assert_select 'p', /#{I18n.t(:label_no_custom_buttons)}/
  end

end
