class AddPublicToCustomButton < ActiveRecord::Migration
  def change
    add_column :custom_buttons, :is_public, :boolean, default: false
  end
end
