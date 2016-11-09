# add link to custom_buttons to my/account
Deface::Override.new(
  virtual_path:  'issues/bulk_edit',
  name:          'bulk_custom_buttons_actions',
  insert_before: 'h2',
  partial:       'custom_buttons/bulk_action_menu_include')
