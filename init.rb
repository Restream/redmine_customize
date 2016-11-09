require 'redmine'

Rails.application.paths['app/overrides'] ||= []
Rails.application.paths['app/overrides'] << File.expand_path('../app/overrides', __FILE__)

Redmine::Plugin.register :redmine_customize do
  name 'Redmine Customization Plugin'
  description 'This plugin provides useful Redmine customization features.'
  author 'Restream'
  version '1.1.0'
  url 'https://github.com/Restream/redmine_customize'

  require File.expand_path('../app/models/customize', __FILE__)

  settings partial: 'settings/redmine_customize', default: Customize.default_settings

  # permission for custom buttons the same as :edit_issues
  Redmine::AccessControl.permission(:edit_issues).actions.push *%w{
      custom_buttons/index
      custom_buttons/new
      custom_buttons/create
      custom_buttons/edit
      custom_buttons/update
      custom_buttons/destroy
  }

  requires_redmine_plugin :redmine__select2, version_or_higher: '1.1.0'

  menu :admin_menu,
    :redmine_customize_settings,
    { controller: 'settings', action: 'plugin', id: 'redmine_customize' },
    html: { class: 'settings' }
end

require 'redmine_customize'
