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

  def select2_options(collection, name = :name, id = :id)
    collection.map do |el|
      { :text => el.send(name), :id => el.send(id) }
    end
  end

  def hruled_list(collection, name = :name)
    collection.map{ |e| h(e.send(name)) }.join('<hr/>').html_safe
  end

end
