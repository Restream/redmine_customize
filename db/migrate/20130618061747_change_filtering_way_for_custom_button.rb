class ChangeFilteringWayForCustomButton < ActiveRecord::Migration
  def change
    remove_columns :custom_buttons,
      :project_id,
      :tracker_id,
      :status_id,
      :category_id,
      :author_id,
      :assigned_to_id
    add_column :custom_buttons, :filters, :text
  end
end
