require File.expand_path('../../test_helper', __FILE__)

class CustomMenuItemTest < ActiveSupport::TestCase

  def test_create_link
    body, url, title = 'link_body', 'http://example.com', 'link_title'
    menu_item        = CustomMenuItem.new(body, url, title)
    assert_equal body, menu_item.body
    assert_equal url, menu_item.url
    assert_equal title, menu_item.title
  end

end
