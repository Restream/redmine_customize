module RedmineCustomize
  USER_ME              = 'me'
  USER_AUTHOR          = 'author'
  USER_LAST_UPDATED_BY = 'last_updated_by'

  FLASH_ACCOUNT_PENDING_KEY = Redmine::VERSION.to_s >= '2.4.0' ? :error : :notice
end

require_dependency 'redmine_customize/patches/project_patch'
require_dependency 'redmine_customize/patches/user_patch'
require_dependency 'redmine_customize/patches/issue_patch'
require_dependency 'redmine_customize/patches/user_preference_patch'
require_dependency 'redmine_customize/patches/issues_helper_patch'
require_dependency 'redmine_customize/patches/i18n_patch'
require_dependency 'redmine_customize/patches/account_controller_patch'
require_dependency 'redmine_customize/patches/application_controller_patch'
require_dependency 'redmine_customize/patches/issues_controller_patch'
require_dependency 'redmine_customize/hooks/view_hooks'
require_dependency 'redmine_customize/hooks/controller_hooks'
require_dependency 'redmine_customize/services/drafts'

ActionDispatch::Callbacks.to_prepare do
  unless Project.included_modules.include? RedmineCustomize::Patches::ProjectPatch
    Project.send :include, RedmineCustomize::Patches::ProjectPatch
  end

  unless User.included_modules.include? RedmineCustomize::Patches::UserPatch
    User.send :include, RedmineCustomize::Patches::UserPatch
  end

  unless Issue.included_modules.include? RedmineCustomize::Patches::IssuePatch
    Issue.send :include, RedmineCustomize::Patches::IssuePatch
  end

  unless UserPreference.included_modules.include?(RedmineCustomize::Patches::UserPreferencePatch)
    UserPreference.send :include, RedmineCustomize::Patches::UserPreferencePatch
  end

  unless Redmine::I18n::Backend.included_modules.include? RedmineCustomize::Patches::I18nPatch
    Redmine::I18n::Backend.send :include, RedmineCustomize::Patches::I18nPatch
  end

  unless AccountController.included_modules.include? RedmineCustomize::Patches::AccountControllerPatch
    AccountController.send :include, RedmineCustomize::Patches::AccountControllerPatch
  end

  unless ApplicationController.included_modules.include? RedmineCustomize::Patches::ApplicationControllerPatch
    ApplicationController.send :include, RedmineCustomize::Patches::ApplicationControllerPatch
  end

  unless IssuesController.included_modules.include? RedmineCustomize::Patches::IssuesControllerPatch
    IssuesController.send :include, RedmineCustomize::Patches::IssuesControllerPatch
  end
end
