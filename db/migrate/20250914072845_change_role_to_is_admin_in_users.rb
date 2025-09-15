class ChangeRoleToIsAdminInUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :role, :integer

    add_column :users, :is_admin, :boolean, default: false, null: false
  end
end
