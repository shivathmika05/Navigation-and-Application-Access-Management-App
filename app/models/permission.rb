class Permission < ApplicationRecord
    belongs_to :user
    belongs_to :application
  
    validates :access_level, inclusion: { in: [1, 2, 3], message: "%{value} is not a valid access level" }
  end
  
  
  