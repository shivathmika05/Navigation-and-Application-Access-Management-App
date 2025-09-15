class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:permissions)
      create_table :permissions do |t|
        t.uuid :user_id, null: false
        t.uuid :application_id, null: false
        t.integer :access_level, default: 0, null: false

        t.timestamps
      end

      add_foreign_key :permissions, :users
      add_foreign_key :permissions, :applications
    end
  end
end
