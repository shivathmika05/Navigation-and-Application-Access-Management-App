class AddAccessLevelToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :access_level, :integer, default: 0, null: false
  end
end
