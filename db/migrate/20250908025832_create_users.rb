class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:users)
      create_table :users, id: :uuid do |t|
        t.string :name, null: false
        t.string :email, null: false
        t.integer :access_level
        t.timestamps
      end

      add_index :users, :email, unique: true
    end
  end
end
