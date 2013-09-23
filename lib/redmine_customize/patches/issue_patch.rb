require 'issue'

module RedmineCustomize::Patches::IssuePatch
  extend ActiveSupport::Concern

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
end

unless Issue.included_modules.include? RedmineCustomize::Patches::IssuePatch
  Issue.send :include, RedmineCustomize::Patches::IssuePatch
end
