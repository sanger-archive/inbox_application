class CreateCheckpoints < ActiveRecord::Migration[5.0]
  def change
    create_table :checkpoints do |t|
      t.references :inbox, foreign_key: true, null: false
      # While direction could be an enum, rails support isn't great
      # and we'd need to write raw sql, which will reduce portability.
      # We'll keep things simple for now.
      t.string :direction, null: false
      t.string :subject_role, null: false
      t.string :event_type, null: false
      t.text :conditions, null: false

      t.timestamps
    end
  end
end
