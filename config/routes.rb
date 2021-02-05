# frozen_string_literal: true

Rails.application.routes.draw do
  resources :users, only: [] do
    resources :payments, only: [:create]

    collection do
      get :feed
      get :balance
    end
  end
end
