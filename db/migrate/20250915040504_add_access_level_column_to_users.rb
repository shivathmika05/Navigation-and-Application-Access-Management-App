class AddAccessLevelColumnToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :access_level, :integer
  end
end
