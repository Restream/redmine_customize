module RedmineCustomizeHelper
  def render_customized_project_jump_box
    hidden_field_tag 'project_quick_jump_box', '',
                     :data => {
                         :options => project_ids_for_jump_box,
                         :placeholder => l(:label_jump_to_a_project)
                     }
  end

  def project_ids_for_jump_box
    projects = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
    root_projects = Project.active.roots.has_module(:issue_tracking).order(:name)
    result = []
    result << {
        :text => l(:label_my_projects),
        :children => projects_tree_for_jump_box(root_projects, :only => projects)
    }
    result << {
        :text => l(:label_public_projects),
        :children => projects_tree_for_jump_box(root_projects, :except => projects)
    }
    result
  end

  # expected option keys are:
  #  :only => []    - array of projects that will be included in tree
  #  :except => []  - array of projects that will be excluded from tree
  def projects_tree_for_jump_box(projects, options = {})
    result = []
    projects.each do |project|

      children = project.children.active.order(:name)
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
    return false unless project.visible?
    return options[:only].include?(project) if options[:only]
    return false if options[:except] && options[:except].include?(project)
    true
  end
end
