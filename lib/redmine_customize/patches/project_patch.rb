require 'project'

module RedmineCustomize::Patches::ProjectPatch
  extend ActiveSupport::Concern

  included do
    has_many :public_drafts

    class << self
      alias_method_chain :allowed_to_condition, :hide_public
    end
  end

  def cached_children
    @cached_children ||= []
  end

  module ClassMethods
    # fill-up cached_children for fast recursive observe of project tree
    def cache_children(projects)
      # first clear cache
      projects.each { |p| p.cached_children.clear }
      roots = []
      ancestors = []
      projects.sort_by(&:lft).each do |project|
        while ancestors.any? && !project.is_descendant_of?(ancestors.last)
          ancestors.pop
        end
        if ancestors.any?
          ancestors.last.cached_children << project
        else
          roots << project
        end
        ancestors << project
      end
      roots
    end

    def allowed_to_condition_with_hide_public(user, permission, options={})
      options.merge!(:member => true) if user.pref[:hide_public_projects] == '1'
      allowed_to_condition_without_hide_public user, permission, options
    end
  end
end

unless Project.included_modules.include? RedmineCustomize::Patches::ProjectPatch
  Project.send :include, RedmineCustomize::Patches::ProjectPatch
end
