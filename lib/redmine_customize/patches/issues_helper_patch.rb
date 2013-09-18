require 'issues_helper'

module RedmineCustomize::Patches::IssuesHelperPatch
  extend ActiveSupport::Concern

  def custom_button_new_values(button, issue = nil)
    new_values = {}
    if issue
      button.new_values.each do |k, v|
        if k == 'assigned_to_id' && v == 'author'
          v = issue.author_id
        end
        if k == 'assigned_to_id' && v == 'me'
          v = User.current.id
        end
        new_values[k] = v if v.present? && issue.safe_attribute?(k)
      end
    else
      button.new_values.each { |k, v| new_values[k] = v if v.present? }
    end
    button.custom_field_values.each do |v|
      field_name = "custom_field_values_#{v.custom_field_id}"
      new_values[field_name] = v.value if v.value.present?
    end
    new_values
  end

  def context_menu_custom_button_new_values(button)
    new_values = custom_button_new_values(button)
    if new_values.has_key?('assigned_to_id')
      new_values['custom_assigned_to_id'] = new_values['assigned_to_id']
      new_values.delete 'assigned_to_id'
    end
    new_values
  end
end

unless IssuesHelper.included_modules.include? RedmineCustomize::Patches::IssuesHelperPatch
  IssuesHelper.send :include, RedmineCustomize::Patches::IssuesHelperPatch
end
