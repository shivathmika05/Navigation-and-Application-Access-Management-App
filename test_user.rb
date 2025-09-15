require './config/environment'

class TestUser < ApplicationRecord
  self.table_name = 'users'



  def access_level_sym
    { 0 => :read_only, 1 => :read_write, 2 => :full_access }[access_level]
  end
end

puts TestUser.column_names
puts TestUser.first&.access_level_sym
