class CreateAppEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :app_events do |t|
      t.string :name
      t.string :location
      t.datetime :date

      t.timestamps
    end
  end
end
