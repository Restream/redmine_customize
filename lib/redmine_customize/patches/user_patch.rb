require 'project'
require 'principal'
require 'user'

module RedmineCustomize::Patches::UserPatch
  extend ActiveSupport::Concern

  included do
    has_many :custom_buttons, :order => 'position'
  end
end

unless User.included_modules.include? RedmineCustomize::Patches::UserPatch
  User.send :include, RedmineCustomize::Patches::UserPatch
end
