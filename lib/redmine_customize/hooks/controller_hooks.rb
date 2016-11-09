module RedmineCustomize::Hooks
  class ControllerHooks < Redmine::Hook::ViewListener
    def controller_issues_bulk_edit_before_save(context = {})
      issue = context[:issue]
      custom_assigned_to_id = context[:params][:issue][:custom_assigned_to_id] rescue nil
      return if issue.nil? || custom_assigned_to_id.blank?
      issue.assigned_to_id =
        issue.custom_user_id(custom_assigned_to_id) || custom_assigned_to_id.to_i
    end

    def controller_issues_new_after_save(context = {})
      if context[:params][:copy_from] && context[:params][:copy_relations].present?
        issue     = context[:issue]
        copy_from = Issue.visible.find(context[:params][:copy_from])
        copy_from.relations_from.each do |relation|
          issue.relations_from.create(issue_to: relation.issue_to, relation_type: relation.relation_type)
        end
        copy_from.relations_to.each do |relation|
          issue.relations_to.create(issue_from: relation.issue_from, relation_type: relation.relation_type)
        end
      end
    end
  end
end
