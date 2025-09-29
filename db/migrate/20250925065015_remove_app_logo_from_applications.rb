class RemoveAppLogoFromApplications < ActiveRecord::Migration[7.0]
  def change
    remove_column :applications, :app_logo, :string
  end
end