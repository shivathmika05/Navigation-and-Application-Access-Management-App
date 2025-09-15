class RemoveUserNumberFromUsers < ActiveRecord::Migration[7.1]
  def change
    if column_exists?(:users, :user_number)
      remove_column :users, :user_number, :integer
    end
  end
end
