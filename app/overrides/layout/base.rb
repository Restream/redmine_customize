# div#top-menu
Deface::Override.new(
    :virtual_path => 'layouts/base',
    :name => 'customize_top_menu',
    :insert_bottom => 'div#top-menu',
    :partial => 'customize/top_menu')

Deface::Override.new(
    :virtual_path => 'layouts/base',
    :name => 'customize_project_jump_box',
    :replace => "code[erb-loud]:contains('render_project_jump_box')",
    :text => '<%= render_customized_project_jump_box %>')
