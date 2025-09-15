class CreateApplications < ActiveRecord::Migration[7.0]
  def change
    unless table_exists?(:applications)
      create_table :applications, id: :uuid do |t|
        t.string :name, null: false
        t.text :description
        t.string :url
        t.string :logo
        t.timestamps
      end
    end
  end
end
