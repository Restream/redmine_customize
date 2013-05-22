# div#top-menu
Deface::Override.new(
    :virtual_path => 'layouts/base',
    :name => 'customize_top_menu',
    :insert_bottom => 'div#top-menu',
    :partial => 'customize/top_menu')
