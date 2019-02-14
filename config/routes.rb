Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'welcome#index'
  get 'welcome/index'

  get 'explore', to: 'explore#index'
  # Route just for modernslaveryregistry.csv
  get 'modernslaveryregistry', to: 'explore#index'
  get 'thanks', to: 'cms#thanks'

  resources :statements, only: :index
  resources :countries
  resources :companies do
    resources :statements do
      resource :snapshot, only: :show
    end
  end

  namespace :admin do
    root 'dashboard#show', as: :dashboard
    resources :pages
    resources :users
    resource :bulk_upload
    resources :companies do
      resources :statements do
        post :mark_url_not_broken, on: :member
        post :snapshot, on: :member
      end
    end
    resources :statements, only: [] do
      collection do
        get :unpublished
      end
    end
  end

  get 'pages/:id', to: 'pages#show', as: :page

  require 'sidekiq/web'
  authenticate(:user, ->(u) { u.admin? }) do
    mount Sidekiq::Web => '/sidekiq'
  end

  get 'health', to: 'health#show', as: :health_check

  get 'wp-login.php', to: proc { [404, {}, ['']] }
end
