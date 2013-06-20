module CustomButtonsHelper
  def project_ids_options_for_select
    root_projects = Project.visible.active.roots.has_module(:issue_tracking).order(:name)
    projects_tree(root_projects)
  end

  def projects_tree(projects)
    result = []
    projects.each do |project|
      result << {
          :text => project.name,
          :id => project.id
      }
      children = project.children.active.has_module(:issue_tracking).order(:name)
      if children.any?
        result << {
            :text => project.name,
            :children => projects_tree(children)
        }
      end
    end
    result
  end

  def find_select2_js_locale(lang)
    url = "select2/select2_locale_#{lang}"
    file_path = File.join(Rails.root, "/plugin_assets/redmine_customize/#{url}")
    url if File.exists?(file_path)
  end

end
