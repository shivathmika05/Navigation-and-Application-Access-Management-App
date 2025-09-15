class DropTestEnumsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :test_enums
  end
end
