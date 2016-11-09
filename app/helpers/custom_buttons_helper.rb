module CustomButtonsHelper
  def project_ids_options_for_select
    root_projects = Project.active.roots.has_module(:issue_tracking).order(:name)
    projects_tree(root_projects)
  end

  def projects_tree(projects)
    result = []
    projects.each do |project|

      if project.visible?
        result << {
          text: project.name,
          id:   project.id
        }
      end

      children      = project.children.active.has_module(:issue_tracking).order(:name)
      children_tree = projects_tree(children)
      if children_tree.any?
        result << {
          text:     project.name,
          children: children_tree
        }
      end
    end
    result
  end

  def select2_options(collection, name = :name, id = :id)
    collection.map do |el|
      { text: el.send(name), id: el.send(id) }
    end
  end

  def hruled_list(collection, name = :name)
    collection.map { |e| h(e.send(name)) }.join('<hr/>').html_safe
  end

  # Return custom field label tag (required ignored!)
  def wor_custom_field_label_tag(name, custom_value, options={})
    content_tag 'label', h(custom_value.custom_field.name),
      for: "#{name}_custom_field_values_#{custom_value.custom_field.id}"
  end

  # Return custom field html tag corresponding to its format (required ignored!)
  def wor_custom_field_tag(name, custom_value)
    return "#{name} = #{custom_value}"
    custom_field = custom_value.custom_field
    field_name   = "#{name}[custom_field_values][#{custom_field.id}]"
    field_name << '[]' if custom_field.multiple?
    field_id = "#{name}_custom_field_values_#{custom_field.id}"

    tag_options = { id: field_id, class: "#{custom_field.field_format}_cf" }

    field_format = ::Redmine::CustomFieldFormat.find_by_name(custom_field.field_format)
    case field_format.try(:edit_as)
      when 'date'
        text_field_tag(field_name, custom_value.value, tag_options.merge(size: 10)) +
          calendar_for(field_id)
      when 'text'
        text_area_tag(field_name, custom_value.value, tag_options.merge(rows: 3))
      when 'bool'
        hidden_field_tag(field_name, '0') + check_box_tag(field_name, '1', custom_value.true?, tag_options)
      when 'list'
        blank_option = ''.html_safe
        unless custom_field.multiple?
          blank_option = content_tag('option')
        end
        s = select_tag(field_name, blank_option + options_for_select(custom_field.possible_values_options(custom_value.customized), custom_value.value),
          tag_options.merge(multiple: custom_field.multiple?))
        if custom_field.multiple?
          s << hidden_field_tag(field_name, '')
        end
        s
      else
        text_field_tag(field_name, custom_value.value, tag_options)
    end
  end

  # Return custom field tag with its label tag (required ignored!)
  def wor_custom_field_tag_with_label(name, custom_value, options={})
    wor_custom_field_label_tag(name, custom_value, options) + wor_custom_field_tag(name, custom_value)
  end

end
