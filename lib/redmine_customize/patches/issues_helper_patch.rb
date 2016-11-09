module RedmineCustomize::Patches::IssuesHelperPatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :show_detail, :attachment_description
  end

  def custom_button_new_values(button, issue = nil)
    new_values = {}
    if issue
      button.new_values.each do |k, v|
        new_value     = if k.to_sym == :assigned_to_id
          issue.custom_user_id(v) || v
        else
          v
        end
        new_values[k] = new_value if new_value.present? && issue.safe_attribute?(k)
      end
    else
      button.new_values.each { |k, v| new_values[k] = v if v.present? }
    end
    button.custom_field_values.each do |v|
      field_name             = "custom_field_values_#{v.custom_field_id}"
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

  def show_detail_with_attachment_description(detail, no_html=false, options={})
    detail_html = show_detail_without_attachment_description(detail, no_html, options)
    issue       = detail.try(:journal).try(:issue) || @issue
    attachment  = issue && detail.property == 'attachment' && issue.attachments.find_by_id(detail.prop_key)
    if attachment
      [
        detail_html,
        (h(" - #{attachment.description}") if attachment.description.present?),
        "<span class=\"size\">(#{number_to_human_size attachment.filesize})</span>"
      ].compact.join(' ').html_safe
    else
      detail_html
    end
  end
end
