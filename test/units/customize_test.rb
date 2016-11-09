require File.expand_path('../../test_helper', __FILE__)

class CustomizeTest < ActiveSupport::TestCase

  def test_add_item_to_the_top_menu
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    item_a           = CustomMenuItem.new(body, url, title)
    a                = Customize.instance
    a.top_menu_items << item_a
    a.save
    b = Customize.instance
    assert_equal 1, b.top_menu_items.count
    item_b = b.top_menu_items[0]
    assert_equal item_b.to_s, item_a.to_s
  end

end
