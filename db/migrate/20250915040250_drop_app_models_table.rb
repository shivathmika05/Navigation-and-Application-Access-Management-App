class DropAppModelsTable < ActiveRecord::Migration[8.0]
  def change
    drop_table :app_models
  end
end

