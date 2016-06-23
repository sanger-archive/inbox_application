class CreateTeamInboxes < ActiveRecord::Migration
  def change
    create_table :team_inboxes do |t|
      t.references :team, index: true, foreign_key: true
      t.references :inbox, index: true, foreign_key: true
      t.integer :order, null: false

      t.timestamps null: false
    end
  end
end
