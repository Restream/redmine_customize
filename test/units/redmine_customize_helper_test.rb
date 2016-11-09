require File.expand_path('../../test_helper', __FILE__)

class RedmineCustomizeHelperTest < ActiveSupport::TestCase
  fixtures :projects, :trackers, :issue_statuses, :issue_categories, :users,
    :issues, :members, :roles, :member_roles, :enumerations,
    :enabled_modules

  include Redmine::I18n
  include RedmineCustomizeHelper
  include Rails.application.routes.url_helpers

  # return just project id instead path
  def project_path(options)
    options[:id].id
  end

  def setup
    stubs(:current_menu_item).returns(nil)
    @version         = Version.new(name: 'test', sharing: 'none')
    @version.project = Project.find(5)
  end

  # Project.id [Members] 	    [public?]
  #   1        [2, 3]          public
  #     5      [2, 8, 1]       private
  #       6                    public
  #     3                      public
  #     4                      public
  #   2 	     [2, 8]          private
  #
  # User(2) My projects: 1:[5], 2; Projects: 1:[5:[6], 3, 4], 2
  # User(3) My projects: 1; Projects: 1:[5*:[6], 3, 4], 2  * - not clickable

  def test_jumpbox_for_member
    User.current = User.find(2)
    ptree        = serialize_project_tree(project_ids_for_jump_box)
    exp_ptree    = serialize_project_tree(
      [
        { text: 'My projects', children:
                [
                  { id: 1, text: 'eCookbook', children:
                        [
                          { id: 5, text: 'Private child of eCookbook' }
                        ]
                  },
                  { id: 2, text: 'OnlineStore' }
                ],
        },
        {
          text: 'Projects', children:
                [
                  { id: 1, text: 'eCookbook', children:
                        [
                          { id: 5, text: 'Private child of eCookbook', children:
                                [
                                  { id: 6, text: 'Child of private child' }
                                ]
                          },
                          { id: 3, text: 'eCookbook Subproject 1' },
                          { id: 4, text: 'eCookbook Subproject 2' },
                        ],
                  },
                  { id: 2, text: 'OnlineStore' }
                ],
        }
      ])
    assert_equal exp_ptree, ptree
  end

  def test_jumpbox_for_non_member
    User.current = User.find(3)
    ptree        = serialize_project_tree(project_ids_for_jump_box)
    exp_ptree    = serialize_project_tree(
      [
        { text: 'My projects', children: [{ id: 1, text: 'eCookbook' }] },
        { text: 'Projects', children:
                [
                  { id: 1, text: 'eCookbook', children:
                        [
                          { text: 'Private child of eCookbook', children:
                                  [
                                    { id: 6, text: 'Child of private child' }
                                  ]
                          },
                          { id: 3, text: 'eCookbook Subproject 1' },
                          { id: 4, text: 'eCookbook Subproject 2' },
                        ],
                  }],
        }
      ])
    assert_equal exp_ptree, ptree
  end

  # serialize hashes with sort by keys
  def serialize_project_tree(ptree)
    case
      when ptree.is_a?(Hash)
        "{ #{ptree.keys.sort.map { |k| ":#{k} => #{serialize_project_tree(ptree[k])}" }.join(', ') } }"
      when ptree.is_a?(Array)
        "[#{ptree.map { |el| serialize_project_tree(el) }.sort.join(', ')}]"
      else
        ptree.to_s
    end
  end

  def test_version_issues_cpath_sharing_none
    @version.sharing = 'none'
    assert_match '/projects/private-child/issues?', version_issues_cpath(@version)
  end

  def test_version_issues_cpath_sharing_descendants
    @version.sharing = 'descendants'
    assert_match '/projects/private-child/issues?', version_issues_cpath(@version)
  end

  def test_version_issues_cpath_sharing_hierarchy
    @version.sharing = 'hierarchy'
    assert_match '/projects/ecookbook/issues?', version_issues_cpath(@version)
  end

  def test_version_issues_cpath_sharing_tree
    @version.sharing = 'tree'
    assert_match '/projects/ecookbook/issues?', version_issues_cpath(@version)
  end

  def test_version_issues_cpath_sharing_system
    @version.sharing = 'system'
    assert_match '/issues?', version_issues_cpath(@version)
  end
end
