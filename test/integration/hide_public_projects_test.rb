require File.expand_path('../../test_helper', __FILE__)
require 'issues_controller'

class HidePublicProjectsTest < ActionDispatch::IntegrationTest
  fixtures :projects, :users, :members, :member_roles, :roles,
    :trackers,
    :enabled_modules,
    :versions,
    :issue_statuses, :issue_categories, :issue_relations,
    :enumerations,
    :issues, :attachments

  def setup
    @user                = User.find(8)
    User.current         = @user
    @public_projects_ids = [1, 3, 4, 6]
    @member_projects_ids = [2, 5]
    @all_projects_ids    = (@public_projects_ids + @member_projects_ids).uniq.sort
  end

  def test_user_can_view_public_projects
    @user.pref[:hide_public_projects] = nil
    @user.pref.save!

    visible_projects_ids = Project.visible(@user).map(&:id).sort

    assert_equal @all_projects_ids, visible_projects_ids

    @all_projects_ids.each do |project_id|
      assert Project.find(project_id).visible?(@user), "Project #{project_id} should be visible"
    end
  end

  def test_user_cannot_view_public_projects
    @user.pref[:hide_public_projects] = '1'
    @user.pref.save!

    visible_projects_ids = Project.visible(@user).map(&:id).sort

    assert_equal @member_projects_ids, visible_projects_ids
    @member_projects_ids.each do |project_id|
      assert Project.find(project_id).visible?(@user), "Project #{project_id} should be visible"
    end
    @public_projects_ids.each do |project_id|
      refute Project.find(project_id).visible?(@user), "Project #{project_id} should not be visible"
    end
  end

end
