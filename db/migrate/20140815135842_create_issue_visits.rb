class CreateIssueVisits < ActiveRecord::Migration
  def change
    create_table :issue_visits do |t|
      t.references :issue, :null => false
      t.references :user, :null => false
      t.datetime :last_visit
      t.integer :visit_count, :null => false, :default => 0

      t.timestamps
    end
    add_index :issue_visits, :user_id
    add_index :issue_visits, [:user_id, :issue_id], :unique => true
  end
end
