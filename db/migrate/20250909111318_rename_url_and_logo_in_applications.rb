class RenameUrlAndLogoInApplications < ActiveRecord::Migration[8.0]
  def change
    rename_column :applications, :url, :app_url
    rename_column :applications, :logo, :app_logo
  end
end

