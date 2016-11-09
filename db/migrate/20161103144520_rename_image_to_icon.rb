class RenameImageToIcon < ActiveRecord::Migration
  def change
    rename_column :custom_buttons, :image, :icon
  end
end
