require_dependency 'issue'

module RedmineCustomize::Patches::IssuePatch
  extend ActiveSupport::Concern

  included do
    alias_method_chain :copy_from, :watchers
    alias_method_chain :siblings, :tablename
  end

  def custom_user_id(custom_label)
    case custom_label
      when RedmineCustomize::USER_AUTHOR
        author_id
      when RedmineCustomize::USER_ME
        User.current.id
      when RedmineCustomize::USER_LAST_UPDATED_BY
        journals.last.try(:user_id) || author_id
      else
        nil
    end
  end

  def copy_from_with_watchers(arg, options = {})
    copy_from_without_watchers(arg, options)
    issue                 = arg.is_a?(Issue) ? arg : Issue.visible.find(arg)
    self.watcher_user_ids = issue.watcher_user_ids
    self
  end

  # Fix redmine siblings method http://www.redmine.org/issues/24296
  def siblings_with_tablename
    nested_set_scope.where(parent_id: parent_id).where("#{self.class.table_name}.id <> ?", id)
  end

end
