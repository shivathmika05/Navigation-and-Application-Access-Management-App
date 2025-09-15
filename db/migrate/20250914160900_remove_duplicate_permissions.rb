class RemoveDuplicatePermissions < ActiveRecord::Migration[7.0]
  def up
    duplicates = Permission
                   .select("MIN(id) AS id, user_id, application_id, COUNT(*) AS count")
                   .group(:user_id, :application_id)
                   .having("COUNT(*) > 1")

    duplicates.each do |dup|
      Permission.where(user_id: dup.user_id, application_id: dup.application_id)
                .where.not(id: dup.id)
                .delete_all
    end
  end

  def down
  end
end
