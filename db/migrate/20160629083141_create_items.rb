class CreateItems < ActiveRecord::Migration
  def change
    create_table :items, id: :uuid, default: 'uuid_generate_v1()'  do |t|
      t.string :name, null: false
      t.text :details
      t.references :inbox, null: false
      t.references :batch, type: :uuid
      t.datetime :completed_at

      t.timestamps null: false
    end
  end
end
