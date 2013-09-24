module RedmineCustomizeHelper
  def render_customized_project_jump_box
    hidden_field_tag 'project_quick_jump_box', '',
                     :data => {
                         :options => project_ids_for_jump_box,
                         :placeholder => l(:label_jump_to_a_project)
                     }
  end

  def project_ids_for_jump_box
    user_projects = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
    visible_projects = Project.active.visible
    active_projects = Project.active
    root_projects = Project.cache_children(active_projects).sort
    result = []
    result << {
        :text => l(:label_my_projects),
        :children => projects_tree_for_jump_box(root_projects, :only => user_projects)
    }
    result << {
        :text => l(:description_choose_project),
        :children => projects_tree_for_jump_box(root_projects,
                                                :only => visible_projects,
                                                :except => user_projects)
    }
    result
  end

  # expected option keys are:
  #  :only => []    - array of projects that will be included in tree
  #  :except => []  - array of projects that will be excluded from tree
  def projects_tree_for_jump_box(projects, options = {})
    result = []
    projects.each do |project|

      children = project.cached_children.sort
      children_tree = projects_tree_for_jump_box(children, options)

      if show_this_project?(project, options)
        result << {
            :text => project.name,
            :id => project_path(:id => project, :jump => current_menu_item)
        }
      end

      if children_tree.any?
        result << {
            :text => project.name,
            :children => children_tree
        }
      end
    end
    result
  end

  private

  def show_this_project?(project, options = {})
    return false if options[:except] && options[:except].include?(project)
    return options[:only].include?(project) if options[:only]
    true
  end
end
