require_dependency 'application_controller'

module RedmineCustomize::Patches::ApplicationControllerPatch
  extend ActiveSupport::Concern

  included do
    before_filter :check_redmine_customize_helper_included
    before_filter :apply_customize_issues_helper_patch
  end

  # A way to make plugin helpers available in all views
  def check_redmine_customize_helper_included
    unless _helpers.included_modules.include? RedmineCustomizeHelper
      self.class.helper RedmineCustomizeHelper
    end
    true
  end

  def apply_customize_issues_helper_patch
    if _helpers.included_modules.include?(IssuesHelper) &&
      !_helpers.included_modules.include?(RedmineCustomize::Patches::IssuesHelperPatch)
      _helpers.send :include, RedmineCustomize::Patches::IssuesHelperPatch
    end
  end
end
