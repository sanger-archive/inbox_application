class AddIndexes < ActiveRecord::Migration[5.0]
  def change
    # For the main ibox view
    add_index :items, [:inbox_id,:completed_at,:batch_id]
    # For a batch view
    add_index :items, :batch_id
  end
end
