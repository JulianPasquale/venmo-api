# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      resources :users, only: [] do
        resources :payments, only: [:create]

        member do
          get :feed
          get :balance
        end
      end
    end
  end
end
