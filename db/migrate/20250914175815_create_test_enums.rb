class CreateTestEnums < ActiveRecord::Migration[8.0]
  def change
    create_table :test_enums do |t|
      t.string :name
      t.integer :access_level

      t.timestamps
    end
  end
end
