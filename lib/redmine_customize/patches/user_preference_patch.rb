require_dependency 'user_preference'

module RedmineCustomize::Patches
  module UserPreferencePatch
    extend ActiveSupport::Concern

    def set_sidebar_block_state(name, is_collapsed)
      blocks = self[:sidebar_blocks] || []
      if is_collapsed
        blocks << name
      else
        blocks.delete(name)
      end
      self[:sidebar_blocks] = blocks.uniq
    end

    def collapsed_sidebar_blocks
      self[:sidebar_blocks] || []
    end

    def hide_public_projects
      self[:hide_public_projects]
    end

    def hide_public_projects=(value)
      self[:hide_public_projects] = value
    end

  end
end
