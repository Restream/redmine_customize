require File.expand_path('../../test_helper', __FILE__)

class RedmineCustomizeHelperTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
           :issues, :members, :roles, :member_roles, :enumerations,
           :enabled_modules

  include Redmine::I18n
  include RedmineCustomizeHelper

  # return just project id instead path
  def project_path(options)
    options[:id].id
  end

  def setup
    stubs(:current_menu_item).returns(nil)
  end

  # Project.id [Members] 	    [public?]
  #   1        [2, 3]          public
  #     5      [2, 8, 1]       private
  #       6                    public
  #     3                      public
  #     4                      public
  #   2 	     [2, 8]          private
  #
  # User(3) 1, 1:[5:[6], 3, 4]

  def test_jumpbox_for_member
    User.current = User.find(2)
    ptree = project_ids_for_jump_box
    exp_ptree = [
        { :children =>
              [{ :id => 1, :text => "eCookbook" },
               { :children => [{ :id => 5, :text => "Private child of eCookbook" }],
                 :text => "eCookbook" },
               { :id => 2, :text => "OnlineStore" }],
          :text => "My projects" },
        { :children =>
              [{ :children =>
                     [{ :children => [{ :id => 6, :text => "Child of private child" }],
                        :text => "Private child of eCookbook" },
                      { :id => 3, :text => "eCookbook Subproject 1" },
                      { :id => 4, :text => "eCookbook Subproject 2" }],
                 :text => "eCookbook" }],
          :text => "Public projects" }
    ]
    assert_equal exp_ptree, ptree
  end

  def test_jumpbox_for_non_member
    User.current = User.find(3)
    ptree = project_ids_for_jump_box
    exp_ptree =[
        { :children => [{ :id => 1, :text => "eCookbook" }], :text => "My projects" },
        { :children =>
              [{ :children =>
                     [{ :children => [{ :id => 6, :text => "Child of private child" }],
                        :text => "Private child of eCookbook" },
                      { :id => 3, :text => "eCookbook Subproject 1" },
                      { :id => 4, :text => "eCookbook Subproject 2" }],
                 :text => "eCookbook" }],
          :text => "Public projects" }
    ]
    assert_equal exp_ptree, ptree
  end
end
