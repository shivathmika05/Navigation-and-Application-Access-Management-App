class RemoveCanReadWriteDeleteFromPermissions < ActiveRecord::Migration[8.0]
  def change
    remove_column :permissions, :can_read, :boolean
    remove_column :permissions, :can_write, :boolean
    remove_column :permissions, :can_delete, :boolean
  end
end
