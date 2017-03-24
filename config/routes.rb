Rails.application.routes.draw do
  get 'welcome/index'
  root 'welcome#index'

  resources :companies do
    resources :statements
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
