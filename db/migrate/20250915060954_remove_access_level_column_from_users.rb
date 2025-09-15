class RemoveAccessLevelColumnFromUsers < ActiveRecord::Migration[8.0]
  def change
    remove_column :users, :access_level, :integer
  end
end

