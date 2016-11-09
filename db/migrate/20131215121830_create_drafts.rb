class CreateDrafts < ActiveRecord::Migration
  def change
    create_table :drafts do |t|
      t.references :project
      t.text :values
      t.string :type
      t.references :user
      t.string :hex_key

      t.timestamps
    end
    add_index :drafts, :project_id
    add_index :drafts, :user_id
    add_index :drafts, :hex_key, unique: true
  end
end
