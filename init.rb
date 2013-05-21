require 'redmine'

Redmine::Plugin.register :redmine_customize do
  name        'Redmine customization plugin'
  description 'Plugin for Redmine customization'
  author      'Undev'
  version     '0.0.1'
  url         'https://github.com/Undev/redmine_customize'

  requires_redmine :version_or_higher => '2.1'
end
