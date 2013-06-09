require File.expand_path('../../../test_helper', __FILE__)
require 'welcome_controller'

class RedmineCustomize::WelcomeControllerTest < ActionController::TestCase
  fixtures :users, :roles, :members, :member_roles

  def setup
    @controller = WelcomeController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @user = User.find(1) # admin
    User.current = @user
    @request.session[:user_id] = @user.id
  end

  def test_show_top_menu
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    item = CustomMenuItem.new(body, url, title)
    cust = Customize.instance
    cust.top_menu_items << item
    cust.save

    get :index
    assert_response :success
    assert_tag :a,
               :content => body,
               :attributes => { :href => url, :title => title }
  end

  def test_show_top_menu_after_change
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    item = CustomMenuItem.new(body, url, title)
    cust = Customize.instance
    cust.top_menu_items << item
    cust.save

    body2, url2, title2 = 'link_2body', 'http://example2.com', 'link_2title'
    Setting['plugin_redmine_customize'] =
        { :top_menu_items => [{ :body => body2, :url => url2, :title => title2 }] }

    get :index
    assert_response :success
    assert_tag :a,
               :content => body2,
               :attributes => { :href => url2, :title => title2 }
  end

end
