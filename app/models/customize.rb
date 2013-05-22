class Customize
  include ActiveModel::Validations

  TOP_MENU_ITEMS = :top_menu_items

  def top_menu_items
    items = settings[TOP_MENU_ITEMS]
    convert_menu_items!(items)
  end

  def update_from_hash(val)
    update_top_menu_item val[TOP_MENU_ITEMS]
  end

  def save
    Setting['plugin_redmine_customize'] = settings
  end

  def initialize(settings = nil)
    @settings = settings
  end

  private

  def update_top_menu_item(val)
    unless val.nil?
      top_menu_items.clear
      tm_items.each do |tm_item|
        item = CustomMenuItem.new(tm_item[:body], tm_item[:url], tm_item[:title])
        top_menu_items << item
      end
    end
  rescue
    errors.add(:base, 'Errors while trying to save top_menu_items')
  end

  def settings
    @settings ||= Setting['plugin_redmine_customize']
  end

  def convert_menu_items!(items)
    items.map! { |item| item.is_a?(CustomMenuItem) ? item : CustomMenuItem.new(item) }
  end
end
