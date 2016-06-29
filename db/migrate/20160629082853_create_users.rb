class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')

    create_table :users , id: :uuid, default: 'uuid_generate_v1()' do |t|
      t.string :login, null: false
      t.timestamps null: false
    end

    add_index :users, :login, unique: true
  end
end
