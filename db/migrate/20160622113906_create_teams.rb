class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :key, null: false
      t.timestamps null: false
    end
    add_index :teams, :key, unique: true
  end
end
