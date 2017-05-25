Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root 'welcome#index'
  get 'welcome/index'

  get 'explore', to: 'explore#index'
  # Route just for modernslaveryregistry.csv
  get 'modernslaveryregistry', to: 'explore#index'
  get 'thanks', to: 'cms#thanks'
  get 'about_us', to: 'cms#about_us'
  get 'reporting_guidance', to: 'cms#reporting_guidance'
  get 'contact_us', to: 'cms#contact_us'

  resources :countries
  resources :companies do
    get :new_statement, on: :collection, as: 'new_company_statement'
    resources :statements
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
