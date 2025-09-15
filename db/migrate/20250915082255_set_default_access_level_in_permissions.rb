class SetDefaultAccessLevelInPermissions < ActiveRecord::Migration[5.2]
  def change
    change_column_default :permissions, :access_level, 1
  end
end
