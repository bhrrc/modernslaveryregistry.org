Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'welcome#index'
  get 'welcome/index'
  post 'welcome/filter'

  get 'explore', to: 'explore#index'
  # Route just for modernslaveryregistry.csv
  get 'modernslaveryregistry', to: 'explore#index'
  get 'thanks', to: 'cms#thanks'

  resources :statements, only: :index
  resources :countries, only: :index
  resources :companies, only: %i[new create show] do
    resources :statements, only: %i[new create index show] do
      resource :snapshot, only: :show
    end
  end

  namespace :admin do
    root 'dashboard#show', as: :dashboard
    resources :pages, except: [:show]
    resources :call_to_actions, except: [:show]
    resources :users, except: [:new]
    resource :bulk_upload, only: [:create]
    resources :stats, only: [:index]
    resources :companies do
      resources :statements, except: [:index], shallow: true do
        post :mark_url_not_broken, on: :member
        post :snapshot, on: :member
      end
    end
  end

  get 'pages/:id', to: 'pages#show', as: :page

  require 'sidekiq/web'
  require "sidekiq/throttled/web"
  authenticate(:user, ->(u) { u.admin? }) do
    Sidekiq::Throttled::Web.enhance_queues_tab!
    mount Sidekiq::Web => '/sidekiq'
  end

end
