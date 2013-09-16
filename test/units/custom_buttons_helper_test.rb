require File.expand_path('../../test_helper', __FILE__)

class CustomButtonsHelperTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
           :issues, :members, :roles, :member_roles, :enumerations,
           :enabled_modules

  include CustomButtonsHelper

  def setup
    User.current = User.find(3)
    Project.find_each do |project|
      project.enable_module!(:issue_tracking)
    end
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

  def test_subproject_of_private_project_is_available
    ptree = project_ids_options_for_select
    exp_ptree = [
        {:id => 1, :text => 'eCookbook'},
        {:children =>
             [{:children => [{:id => 6, :text => 'Child of private child'}],
               :text => 'Private child of eCookbook'},
              {:id => 3, :text => 'eCookbook Subproject 1'},
              {:id => 4, :text => 'eCookbook Subproject 2'}],
         :text => 'eCookbook'}
    ]
    assert_equal exp_ptree, ptree
  end
end
