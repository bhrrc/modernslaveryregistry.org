Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'welcome#index'
  get 'welcome/index'

  get 'explore', to: 'explore#index'
  # Route just for modernslaveryregistry.csv
  get 'modernslaveryregistry', to: 'explore#index'
  get 'thanks', to: 'cms#thanks'

  resources :countries
  resources :companies do
    get :new_statement, on: :collection, as: 'new_company_statement'
    resources :statements do
      resource :snapshot, only: :show
      post :mark_url_not_broken, on: :member
    end
  end

  namespace :admin do
    root 'dashboard#show', as: :dashboard
    resources :pages
    resources :users
  end

  get 'pages/:id', to: 'pages#show', as: :page

  require 'sidekiq/web'
  authenticate(:user, ->(u) { u.admin? }) do
    mount Sidekiq::Web => '/sidekiq'
  end
end
