class AddHideWhenNothingChangeToCustomButtons < ActiveRecord::Migration
  def change
    add_column :custom_buttons, :hide_when_nothing_change, :boolean, default: false
  end
end
