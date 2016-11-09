require_dependency 'project'
require_dependency 'principal'
require_dependency 'user'

module RedmineCustomize::Patches::UserPatch
  extend ActiveSupport::Concern

  included do
    has_many :custom_buttons
    alias_method_chain :allowed_to?, :hide_public_projects
  end

  def visible_custom_buttons(issue_or_issues)
    issues = [issue_or_issues].flatten.compact
    return [] if issues.empty?

    btns = custom_buttons.is_private.to_a + CustomButton.is_public.by_position.to_a
    btns.uniq{ |b| b.id }.find_all do |b|
      issues.inject(true) { |visible, issue| visible && b.visible?(issue) }
    end
  end

  def allowed_to_with_hide_public_projects?(action, context, options={}, &block)
    if pref[:hide_public_projects] == '1' && context && context.is_a?(Project)
      return false unless context.allows_to?(action)
      # Admin users are authorized for anything else
      return true if admin?

      roles = roles_for_project(context)
      return false unless roles
      roles.any? { |role|
        role.member? && role.allowed_to?(action) && (block_given? ? yield(role, self) : true)
      }
    else
      allowed_to_without_hide_public_projects?(action, context, options, &block)
    end
  end
end
