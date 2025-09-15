class DropExtraUserTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :user, if_exists: true
    drop_table :users_new, if_exists: true
  end
end
