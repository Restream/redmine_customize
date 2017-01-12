module RedmineCustomizeHelper
  def render_project_jump_box
    select_tag 'project_quick_jump_box', options_for_select2_projects_tree,
      data:          { placeholder: l(:label_jump_to_a_project) },
      include_blank: true,
      style:         'width: 300px'
  end

  def options_for_select2_projects_tree(selected = nil)
    user_projects    = User.current.memberships.collect(&:project).compact.select(&:active?).uniq
    visible_projects = Project.active.visible
    active_projects  = Project.active
    root_projects    = Project.cache_children(active_projects).sort
    result           = ''.html_safe
    selected         = selected.clone if selected

    # Options for user's projects
    group_id         = next_jump_id
    user_projects    = content_tag(:optgroup, label: l(:label_my_projects), data: { id: group_id }) do
      projects_tree_options(root_projects,
        selected:  selected,
        only:      user_projects,
        allowed:   visible_projects,
        parent_id: group_id)
    end
    result.safe_concat user_projects

    # Options for all projects
    group_id     = next_jump_id
    all_projects = content_tag(:optgroup, label: l(:description_choose_project), data: { id: group_id }) do
      projects_tree_options(root_projects,
        selected:  selected,
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
  def projects_tree_options(projects, options = {})
    result = ''.html_safe
    projects.each do |project|

      allowed  = allowed_to_jump?(project, options)
      selected = options[:selected] && options[:selected].delete(project.id.to_s)
      level    = options.fetch(:level, 0)
      children = project.cached_children.sort
      is_leaf  = show_project_as_leaf?(project, options) || children.empty?
      value    = allowed ? project_path(id: project, jump: current_menu_item) : nil
      css      = "jump-box-lvl#{ level }"
      css << ' jump-box-group' unless is_leaf

      # Generate unique id for option tag
      option_id = next_jump_id

      children_options = is_leaf ?
        projects_tree_options(children, options.merge(level: level + 1, parent_id: option_id)) : nil

      # Show item only if it include in "only" or has children
      if !children_options.blank? || show_project_as_leaf?(project, options)
        result.safe_concat content_tag(:option, project.name,
          selected: selected,
          disabled: !allowed,
          value:    project.id,
          data:     { id: option_id, parent_id: options[:parent_id], jump: value },
          class:    css)

        result.safe_concat children_options unless children_options.blank?
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
