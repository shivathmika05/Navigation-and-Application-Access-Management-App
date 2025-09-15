class AddUrlAndLogoToApplications < ActiveRecord::Migration[8.0]
  def change
    add_column :applications, :url, :string
    add_column :applications, :logo, :string
  end
end
