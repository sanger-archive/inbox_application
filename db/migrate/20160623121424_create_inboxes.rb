class CreateInboxes < ActiveRecord::Migration
  def change
    create_table :inboxes do |t|
      t.string :name, null: false
      t.string :key, null: false

      t.timestamps null: false
    end
    add_index :inboxes, :key, unique: true
  end
end
