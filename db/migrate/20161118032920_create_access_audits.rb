class CreateAccessAudits < ActiveRecord::Migration
  def change
    create_table :access_audits do |t|
      t.string 	:username
      t.string 	:action, null: false
      t.text 	:description

      t.timestamps null: false
    end
  end
end
