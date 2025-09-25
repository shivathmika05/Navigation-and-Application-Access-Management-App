class Permission < ApplicationRecord
    belongs_to :user
    belongs_to :application
  
    validates :access_level, inclusion: { in: [1, 2, 3], message: "%{value} is not a valid access level" }
  
    def app_url
      application&.app_url
    end
  
    def features
      case access_level
      when 1
        ["read"]
      when 2
        ["read", "write"]
      when 3
        ["read", "write", "delete"]
      else
        []
      end
    end
  end
  