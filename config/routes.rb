Rails.application.routes.draw do
  root 'home#index'
  mount Anotoki::Engine, at: "anotoki"
  namespace :api, {  format: 'json' } do
    get "screenshot" => "screenshot#index"
  end
end