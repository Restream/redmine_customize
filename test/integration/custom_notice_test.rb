require File.expand_path('../../test_helper', __FILE__)

class CustomNoticeTest < ActionController::IntegrationTest
  fixtures :users, :roles

  include Redmine::I18n

  def test_show_standard_notice
    with_settings :default_language => 'en' do
      Setting.self_registration = '2'
  
      post 'account/register', :user => {:login => 'newuser', :language => 'en',
                                         :firstname => 'New', :lastname => 'User',
                                         :mail => 'newuser@foo.bar', :password => 'newpass123',
                                         :password_confirmation => 'newpass123'}
      assert_redirected_to '/login'
      assert_equal l(:notice_account_pending), flash[:notice]
    end
  end

  def test_show_custom_notice
    with_settings :default_language => 'en' do
      Setting.self_registration = '2'

      log_user('admin', 'admin')

      post 'settings/plugin/redmine_customize',
           :settings => { :notice_account_pending => 'Custom Notice' }


      User.current = nil

      post 'account/register', :user => {:login => 'newuser', :language => 'en',
                                         :firstname => 'New', :lastname => 'User',
                                         :mail => 'newuser@foo.bar', :password => 'newpass123',
                                         :password_confirmation => 'newpass123'}
      assert_redirected_to '/login'
      assert_equal 'Custom Notice', flash[:notice]
    end
  end

end
