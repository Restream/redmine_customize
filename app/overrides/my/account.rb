# add link to custom_buttons to my/account
Deface::Override.new(
  virtual_path: 'my/account',
  name:         'custom_buttons_panel',
  insert_after: 'div.splitcontentright fieldset.box:first-child',
  partial:      'custom_buttons/panel')
