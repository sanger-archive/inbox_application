class CreateItems < ActiveRecord::Migration
  def change
    create_table :items  do |t|
      t.uuid :uuid, null:false
      t.string :name, null: false
      t.text :details
      t.references :inbox, null: false
      t.references :batch
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
