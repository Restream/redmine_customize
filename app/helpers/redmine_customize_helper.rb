module RedmineCustomizeHelper
  def render_project_jump_box
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
        :children => projects_tree_for_jump_box(root_projects,
                                                :only => user_projects,
                                                :allowed => visible_projects)
    }
    result << {
        :text => l(:description_choose_project),
        :children => projects_tree_for_jump_box(root_projects,
                                                :only => visible_projects,
                                                :allowed => visible_projects)
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

      node = {}

      node.merge!(
          :text => project.name
      ) if show_project_as_leaf?(project, options)

      node.merge!(
          :text => project.name,
          :children => children_tree
      ) if children_tree.any?

      node.merge!(
          :id => project_path(:id => project, :jump => current_menu_item)
      ) if !node.empty? && allowed_to_jump?(project, options)

      result << node unless node.empty?
    end
    result
  end

  def version_issues_cpath(version, options = {})
    options = {
        :fixed_version_id => version,
        :set_filter => 1
    }.merge(options)
    project = case version.sharing
                when 'hierarchy', 'tree'
                  version.project.root if version.project.root.visible?
                when 'system'
                  nil
                else
                  version.project
              end
    project ? project_issues_path(project, options) : issues_path(options)
  end

  private

  def show_project_as_leaf?(project, options = {})
    return false if options[:except] && options[:except].include?(project)
    return options[:only].include?(project) if options[:only]
    true
  end

  def allowed_to_jump?(project, options = {})
    options[:allowed] ? options[:allowed].include?(project) : false
  end
end
