class CreateRoleAssignments < ActiveRecord::Migration
  def change
    create_table :role_assignments do |t|
      t.integer :role_id, null: false
      t.integer :user_id, null: false
      t.datetime :deleted_at, null: true
      t.timestamps
    end
  end
end