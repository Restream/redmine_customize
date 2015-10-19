module RedmineCustomize::Hooks
  class ViewHooks < Redmine::Hook::ViewListener
    render_on :view_issues_context_menu_end,
              :partial => 'custom_buttons/view_issues_context_menu'
    render_on :view_layouts_base_html_head,
              :partial => 'customize/layouts_base_html_head'
    render_on :view_issues_form_details_bottom,
              :partial => 'customize/issues_form_details_bottom'
    render_on :view_issues_show_description_bottom,
              :partial => 'customize/issues_show_description_bottom'

    def view_issues_show_details_bottom(_ = {})
      javascript_include_tag('custom_buttons', :plugin => 'redmine_customize') +
          javascript_include_tag('highlight_note', :plugin => 'redmine_customize')
    end

    def view_issues_bulk_edit_details_bottom(_ = {})
      javascript_include_tag 'custom_buttons_bulk_edit',
                             :plugin => 'redmine_customize'
    end

    def view_layouts_base_body_bottom(_ = {})
      javascript_tag "initSidebar(\"#{sidebar_block_path('')}\", #{User.current.pref.collapsed_sidebar_blocks.to_json});"
    end

    def view_issues_new_top(_ = {})
      javascript_include_tag 'get_url_link', :plugin => 'redmine_customize'
    end
  end
end
