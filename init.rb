require 'redmine'

Rails.application.paths['app/overrides'] ||= []
Rails.application.paths['app/overrides'] << File.expand_path('../app/overrides', __FILE__)

ActionDispatch::Callbacks.to_prepare do
  require 'redmine_customize'
end

Redmine::Plugin.register :redmine_customize do
  name        'RedmineCustomize plugin'
  description 'Plugin for Redmine customization'
  author      'Undev'
  version     '0.4.6'
  url         'https://github.com/Undev/redmine_customize'

  requires_redmine :version_or_higher => '2.1'

  require File.expand_path('../app/models/customize', __FILE__)

  settings :partial => 'settings/redmine_customize',
           :default => Customize.default_settings

  # permission for custom buttons the same as :edit_issues
  Redmine::AccessControl.permission(:edit_issues).actions.push *%w{
      custom_buttons/index
      custom_buttons/new
      custom_buttons/create
      custom_buttons/edit
      custom_buttons/update
      custom_buttons/destroy
  }

  requires_redmine_plugin :redmine__select2, :version_or_higher => '1.0.1'
end
