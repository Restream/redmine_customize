# add link to custom_buttons to my/account
Deface::Override.new(
    :virtual_path => 'issues/_action_menu',
    :name => 'custom_buttons_actions',
    :insert_bottom => 'div.contextual',
    :partial => 'custom_buttons/action_menu_include')
