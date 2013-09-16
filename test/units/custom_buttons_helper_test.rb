require File.expand_path('../../test_helper', __FILE__)

class CustomButtonsHelperTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
           :issues, :members, :roles, :member_roles, :enumerations,
           :enabled_modules

  include CustomButtonsHelper

  def setup
    User.current = User.find(2)
  end

  #Project.id [Members] 	[public ?]
  #1 	[2,3]		public
  #5 	[2, 8, 1]	private
  #6			public
  #3			public
  #4			public
  #2 	[2, 8]		private
  #
  #User(2) 1(5(6),3,4),2
  #User(3) 1(5*(6),3,4)
  #
  def test_subproject_of_private_project_is_available
    ptree = project_ids_options_for_select
    exp_ptree = [
        { :id => 1, :text => 'eCookbook' },
        { :text => 'eCookbook',
          :children=> [{ :id => 3, :text => 'eCookbook Subproject 1' }]
        }
    ]
    assert_equal exp_ptree, ptree
  end
end
