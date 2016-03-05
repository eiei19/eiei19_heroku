Anotoki::Engine.routes.draw do
  root 'news#index'
  get '/:yyyy/:mm/:dd', to: 'news#date', constraints: {yyyy: /\d{4}/, mm: /\d{2}/, dd: /\d{2}/}
  get '/:yyyy/:mm/:dd/:keyword', to: 'news#keyword', constraints: {yyyy: /\d{4}/, mm: /\d{2}/, dd: /\d{2}/}
end
