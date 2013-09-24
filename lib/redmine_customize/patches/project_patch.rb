require 'project'

module RedmineCustomize::Patches::ProjectPatch
  extend ActiveSupport::Concern

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

  end
end

unless Project.included_modules.include? RedmineCustomize::Patches::ProjectPatch
  Project.send :include, RedmineCustomize::Patches::ProjectPatch
end
