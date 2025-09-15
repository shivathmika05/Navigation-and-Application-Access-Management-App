class CreateAppModels < ActiveRecord::Migration[8.0]
  def change
    create_table :app_models do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
