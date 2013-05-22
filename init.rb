require 'redmine'

Rails.application.paths['app/overrides'] ||= []
Rails.application.paths['app/overrides'] << File.expand_path('../app/overrides', __FILE__)

ActionDispatch::Callbacks.to_prepare do
  require 'redmine_customize'
end

Redmine::Plugin.register :redmine_customize do
  name        'Redmine customization plugin'
  description 'Plugin for Redmine customization'
  author      'Undev'
  version     '0.0.1'
  url         'https://github.com/Undev/redmine_customize'

  requires_redmine :version_or_higher => '2.1'

  settings :default => { RedmineCustomize::TOP_MENU_ITEMS => [] }

end
