class AddPublicToCustomButton < ActiveRecord::Migration
  def change
    add_column :custom_buttons, :is_public, :boolean, :default => 0
  end
end
