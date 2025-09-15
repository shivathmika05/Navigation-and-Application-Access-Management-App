class User < ApplicationRecord
    has_many :permissions, dependent: :destroy
    has_many :applications, through: :permissions


    def can_write?(application)
      permission = permissions.find_by(application_id: application.id)
      permission.present? && permission.access_level >= 2
    end

    def can_read?(application)
      permission = permissions.find_by(application_id: application.id)
      permission.present? && permission.access_level >= 1
    end

    def can_delete?(application)
      permission = permissions.find_by(application_id: application.id)
      permission.present? && permission.access_level >= 3
    end
end
