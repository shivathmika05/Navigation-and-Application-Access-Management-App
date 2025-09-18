Rails.application.routes.draw do
  resources :users
  resources :applications

  resources :permissions, only: [:index, :create] do
    collection do
      get "by_user/:user_id", to: "permissions#by_user"
      put "update_by_user/:user_id/:app_id", to: "permissions#update_by_user"
      delete "", to: "permissions#destroy"  
    end
  end
end


