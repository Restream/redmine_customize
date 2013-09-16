class SidebarBlocksController < ApplicationController
  before_filter :require_login

  def update
    name = params[:id]
    is_collapsed = params[:block][:is_collapsed] == 'true'
    pref = User.current.pref
    pref.set_sidebar_block_state(name, is_collapsed)
    pref.save!
    render nothing: true
  end
end
