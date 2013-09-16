module RedmineCustomize::Hooks
  class ViewHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(_ = {})
      stylesheet_link_tag('redmine_customize', :plugin => 'redmine_customize') +
        javascript_include_tag('sidebar_collapse', :plugin => 'redmine_customize')
    end

    def view_issues_show_details_bottom(_ = {})
      javascript_include_tag 'custom_buttons', :plugin => 'redmine_customize'
    end

    def view_layouts_base_body_bottom(_ = {})
      javascript_tag "initSidebar(\"#{sidebar_block_path('')}\", #{User.current.preference.collapsed_sidebar_blocks.to_json});"
    end
  end
end
