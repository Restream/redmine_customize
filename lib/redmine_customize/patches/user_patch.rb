require 'project'
require 'principal'
require 'user'

module RedmineCustomize::Patches::UserPatch
  extend ActiveSupport::Concern

  included do
    has_many :custom_buttons, :order => 'position'
  end

  def visible_custom_buttons(issue)
    custom_buttons.find_all { |b| b.visible?(issue) }
  end
end

unless User.included_modules.include? RedmineCustomize::Patches::UserPatch
  User.send :include, RedmineCustomize::Patches::UserPatch
end
