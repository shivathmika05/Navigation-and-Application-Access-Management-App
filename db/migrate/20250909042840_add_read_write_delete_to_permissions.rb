class AddReadWriteDeleteToPermissions < ActiveRecord::Migration[8.0]
  def change
    add_column :permissions, :can_read, :boolean, default: true, null: false
    add_column :permissions, :can_write, :boolean, default: false, null: false
    add_column :permissions, :can_delete, :boolean, default: false, null: false
  end
end

