require File.expand_path('../../test_helper', __FILE__)

class CustomizeTest < ActiveSupport::TestCase

  def test_add_item_to_the_top_menu
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    item_a = CustomMenuItem.new(body, url, title)
    a = Customize.new
    a.top_menu_items << item_a
    a.save
    b = Customize.new
    assert_equal 1, b.top_menu_items.count
    item_b = b.top_menu_items[0]
    assert_equal item_b.to_s, item_a.to_s
  end

  def test_create_with_settings
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    settings = { :top_menu_items => [ {
        :body => body, :url => url, :title => title } ] }
    customize = Customize.new(settings)
    menu_item = customize.top_menu_items.last
    assert_not_nil menu_item
    assert_equal body,  menu_item.body
    assert_equal url,   menu_item.url
    assert_equal title, menu_item.title
  end
  
end
