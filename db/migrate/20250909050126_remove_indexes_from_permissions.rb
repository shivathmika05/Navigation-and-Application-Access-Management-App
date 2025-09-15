class RemoveIndexesFromPermissions < ActiveRecord::Migration[8.0]
  def change
    remove_index :permissions, column: :application_id, name: "index_permissions_on_application_id"
    remove_index :permissions, column: :user_id, name: "index_permissions_on_user_id"
  end
end

