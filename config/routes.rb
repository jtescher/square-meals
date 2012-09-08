SquareMeals::Application.routes.draw do
  get 'oauth2' => 'sessions#create', as: :oauth_callback
  root to: 'home#index'
end
