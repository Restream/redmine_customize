class RedmineCustomize
  TOP_MENU_ITEMS = :top_menu_items

  def top_menu_items
    settings[TOP_MENU_ITEMS]
  end

  def save!
    Setting['plugin_redmine_customize'] = settings
  end

  private

  def settings
    @settings ||= Setting['plugin_redmine_customize']
  end

end
