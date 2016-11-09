# add preferences 'Hide public projects'
Deface::Override.new(
  virtual_path: 'users/_preferences',
  name:         'add_hide_public_projects_pref',
  insert_after: 'code[erb-loud]:contains("labelled_fields_for :pref, @user.pref do |pref_fields|")',
  text:         <<PREF

<%= render 'users/hide_public_projects_pref', pref_fields: pref_fields %>
PREF
)
