# add link to custom_buttons to my/account
Deface::Override.new(
  virtual_path: 'issues/new',
  name:         'get_url_link',
  insert_after: "code[erb-loud]:contains('preview_link')",
  text:         "<%= link_to l(:label_get_url), '#', id: 'get-url-link', class: 'icon custom-icon-table_link', " +
                  'data: { url: project_draft_issues_url(@project.identifier, only_path: false) } %>')
