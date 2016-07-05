Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'teams#index'

  resources :teams, param: :key do
    resources :inboxes, param: :key, controller: 'teams/inboxes'
  end

  resources :inboxes, param: :key do
    resources :batches, only: [:create,:show,:destroy]
  end

  resources :batches, only: [:create,:show,:destroy]

end
