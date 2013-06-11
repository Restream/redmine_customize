module RedmineCustomize::Hooks
  class ViewHooks < Redmine::Hook::ViewListener
    def view_layouts_base_html_head(_ = {})
      stylesheet_link_tag 'redmine_customize', :plugin => 'redmine_customize'
    end

    def view_issues_show_details_bottom(_ = {})
      javascript_include_tag 'custom_buttons', :plugin => 'redmine_customize'
    end
  end
end
