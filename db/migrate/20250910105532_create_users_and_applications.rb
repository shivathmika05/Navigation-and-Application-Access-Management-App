class CreateUsersAndApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.integer :role, default: 0, null: false
      t.timestamps
    end
    add_index :users, :email, unique: true

    create_table :applications do |t|
      t.string :name, null: false
      t.text :description
      t.string :app_url
      t.string :app_logo
      t.timestamps
    end

    create_table :permissions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :application, null: false, foreign_key: true
      t.integer :access_level, default: 0, null: false
      t.timestamps
    end
  end
end

