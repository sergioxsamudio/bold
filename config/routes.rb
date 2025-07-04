Rails.application.routes.draw do
  resources :scans, only: [:new, :create]
  root "scans#new"
  get 'estacion3', to: 'scans#estacion3'
  match 'tv_display', to: 'scans#tv_display', via: [:get, :post]
  get 'estacion2', to: 'scans#estacion2'
  get 'estacion5', to: 'scans#estacion5'
  get 'scans/buscar_participante', to: 'scans#buscar_participante'
  post 'scans/redimir', to: 'scans#redimir'


end

