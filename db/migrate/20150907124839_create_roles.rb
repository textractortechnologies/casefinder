class CreateRoles < ActiveRecord::Migration
  def change
    create_table :roles do |t|
      t.string :name, null: false
      t.string :external_identifier, null: false
      t.datetime :deleted_at, null: true
      t.timestamps
    end
  end
end