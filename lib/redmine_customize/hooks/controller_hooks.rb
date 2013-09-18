module RedmineCustomize::Hooks
  class ControllerHooks < Redmine::Hook::ViewListener
    def controller_issues_bulk_edit_before_save(context = {})
      issue = context[:issue]
      custom_assigned_to_id = context[:params][:issue][:custom_assigned_to_id] rescue nil
      return if issue.nil? || custom_assigned_to_id.blank?
      issue.assigned_to_id = case custom_assigned_to_id
        when 'author' then issue.author_id
        when 'me' then User.current
        else custom_assigned_to_id.to_i
      end
    end
  end
end
