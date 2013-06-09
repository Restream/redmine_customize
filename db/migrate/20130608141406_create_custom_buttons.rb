class CreateCustomButtons < ActiveRecord::Migration
  def change
    create_table :custom_buttons do |t|
      t.references :user
      t.string :name
      t.string :title
      t.string :image
      t.integer :position
      t.references :project
      t.references :tracker
      t.references :status
      t.references :category
      t.references :author
      t.references :assigned_to
      t.text :new_values

      t.timestamps
    end
    add_index :custom_buttons, :user_id
    add_index :custom_buttons, [:user_id, :position]
  end
end
