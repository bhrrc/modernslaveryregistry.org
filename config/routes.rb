Rails.application.routes.draw do
  devise_for :users
  get 'welcome/index'
  root 'welcome#index'

  get 'explore', to: 'explore#index'

  resources :countries
  resources :companies do
    get :new_statement, on: :collection, as: 'new_company_statement'
    resources :statements
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
