Rails.application.routes.draw do
  root "home#index"
  get '/methodology', to: 'home#methodology'
  get '/tableau', to: 'home#tableau'
  get '/delay_chart', to: 'carriers#delay_chart'
  get '/taxi_chart', to: 'carriers#taxi_chart'
  get '/rate_chart', to: 'carriers#rate_chart'
  post '/destination_search', to: 'carriers#destination_search'

  resources :carriers, only: [:index, :show]
end
