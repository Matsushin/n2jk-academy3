Rails.application.routes.draw do
  resources :posts, only: %i(index)

  resources :users do
    resource :posts do
      collection do
        patch 'readall'
      end
      resource :comments do
        collection do
          patch 'readall'
        end
      end
    end
  end

  get 'auth/github/callback' => 'sessions#create'
  get 'signin' => 'sessions#new', as: :signin
  delete 'signout' => 'sessions#destroy', as: :signout
  root 'home#index'
end
