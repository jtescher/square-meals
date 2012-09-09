SquareMeals::Application.routes.draw do
  resources :restaurants
  get 'oauth2' => 'sessions#create', as: :oauth_callback
  get 'logout' => 'sessions#destroy'
  root to: 'home#index'
end
