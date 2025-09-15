class DropUsersAndApplications < ActiveRecord::Migration[8.0]
  def change
    # Drop permissions first because it depends on users/applications
    drop_table :permissions, if_exists: true

    # Now drop the dependent tables
    drop_table :users, if_exists: true, force: :cascade
    drop_table :applications, if_exists: true, force: :cascade
  end
end
