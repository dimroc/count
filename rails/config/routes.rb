Rails.application.routes.draw do
  devise_for :users
  mount ActionCable.server => "/cable"

  namespace :admin do
    root to: redirect('admin/mockups')
    resources :mockups, only: [:index, :show]
    resources :shakecams, only: [:index]
    resources :malls, only: [:index]
    resources :frames, only: [:update]
  end

  root to: 'marketings#index'
  resources :shakecams, only: [:index]
  resources :malls, only: [:index]

  get "/dates/:date", to: "marketings#index"
  get "/dates/:date/frames/:frame", to: "marketings#index"
end
