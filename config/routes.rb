Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      resources :app_events, only: [:index, :show, :create, :update, :destroy]
    end
  end

  # User routes
  resources :users do
    collection do
      get 'by_email_with_app/:email/:app_id', to: 'users#by_email_with_app'
      get 'by_email/:email', to: 'users#by_email'
      put 'update/:id', to: 'users#update'
    end
  end
  

  # Application routes
  resources :applications do
    collection do
      get 'permissions/:user_id/apps/:app_id', to: 'applications#get_app_permissions'
    end
  end

  # Permission routes
  resources :permissions, only: [:index, :show, :create, :update, :destroy] do
    collection do
      get 'by_user/:user_id', to: 'permissions#by_user'
      put 'update_by_user/:user_id/:app_id', to: 'permissions#update_by_user'
      get 'user_app_access/:user_id/:app_id', to: 'permissions#user_app_access'
      delete 'delete_by_user_app/:user_id/:application_id', to: 'permissions#destroy_by_user_app'
    end
  end
end
