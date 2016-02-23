Rails.application.routes.draw do
  root 'home#index'
  mount Anotoki::Engine, at: "anotoki"
end