module RedmineCustomizeHelper
  def render_project_jump_box
    select_tag('project_quick_jump_box', options_for_select2_jump_box, data: { placeholder: l(:label_jump_to_a_project) })
  end

  def options_for_select2_jump_box
    user_projects    = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
    visible_projects = Project.active.visible
    active_projects  = Project.active
    root_projects    = Project.cache_children(active_projects).sort
    result           = ''.html_safe

    # Options for user's projects
    group_id         = next_jump_id
    user_projects    = content_tag(:optgroup, label: l(:label_my_projects), data: { id: group_id }) do
      projects_tree_for_jump_box(root_projects,
        only:      user_projects,
        allowed:   visible_projects,
        parent_id: group_id)
    end
    result.safe_concat user_projects

    # Options for all projects
    group_id     = next_jump_id
    all_projects = content_tag(:optgroup, label: l(:description_choose_project), data: { id: group_id }) do
      projects_tree_for_jump_box(root_projects,
        only:      visible_projects,
        allowed:   visible_projects,
        parent_id: group_id)
    end
    result.safe_concat all_projects

    result
  end

  # expected option keys are:
  #  only: []    - array of projects that will be included in tree
  #  except: []  - array of projects that will be excluded from tree
  def projects_tree_for_jump_box(projects, options = {})
    result = ''.html_safe
    projects.each do |project|

      level    = options.fetch(:level, 0)
      children = project.cached_children.sort
      is_leaf  = show_project_as_leaf?(project, options) || children.empty?
      value    = allowed_to_jump?(project, options) ? project_path(id: project, jump: current_menu_item) : nil
      css      = "jump-box-lvl#{ level }"
      css << ' jump-box-group' unless is_leaf

      option_id = next_jump_id
      result.safe_concat content_tag(:option, project.name,
        value: value,
        data:  { id: option_id, parent_id: options[:parent_id] },
        class: css)

      unless is_leaf
        result.safe_concat projects_tree_for_jump_box(children, options.merge(level: level + 1, parent_id: option_id))
      end

    end
    result
  end

  def version_issues_cpath(version, options = {})
    options = {
      fixed_version_id: version,
      set_filter:       1
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
    options[:allowed] && options[:allowed].include?(project)
  end

  def next_jump_id
    @jump_id ||= 0
    @jump_id += 1
  end
end
