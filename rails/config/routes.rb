Rails.application.routes.draw do
  devise_for :users
  root to: 'marketings#index'

  mount ActionCable.server => "/cable"

  namespace :admin do
    root to: redirect('admin/mockups')
    resources :mockups, only: [:index, :show]
    resources :shakecams, only: [:index]
    resources :malls, only: [:index]
    resources :frames, only: [:update]
  end
end
