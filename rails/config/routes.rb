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

  get "/date/:date", to: "marketings#index"
  get "/date/:date/time/:time", to: "marketings#index"
end
