class CreateTeamInboxes < ActiveRecord::Migration
  def change
    create_table :team_inboxes do |t|
      t.references :team, index: true, foreign_key: true, null: false
      t.references :inbox, index: true, foreign_key: true, null: false
      t.integer :order, null: false

      t.timestamps null: false
    end
  end
end
