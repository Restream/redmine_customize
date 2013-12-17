module RedmineCustomize
  USER_ME = 'me'
  USER_AUTHOR = 'author'
  USER_LAST_UPDATED_BY = 'last_updated_by'
end

require 'redmine_customize/patches/project_patch'
require 'redmine_customize/patches/user_patch'
require 'redmine_customize/patches/issue_patch'
require 'redmine_customize/patches/user_preference_patch'
require 'redmine_customize/patches/issues_helper_patch'
require 'redmine_customize/patches/i18n_patch'
require 'redmine_customize/patches/application_controller_patch'
require 'redmine_customize/patches/issues_controller_patch'
require 'redmine_customize/hooks/view_hooks'
require 'redmine_customize/hooks/controller_hooks'
require 'redmine_customize/services/drafts'
