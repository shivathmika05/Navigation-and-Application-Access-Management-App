class AddUniqueIndexToPermissions < ActiveRecord::Migration[7.0]
  def change
    add_index :permissions, [ :user_id, :application_id ], unique: true
  end
end
