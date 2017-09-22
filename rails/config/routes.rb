Rails.application.routes.draw do
  devise_for :users
  root to: 'marketings#index'

  authenticate :user, lambda { |u| u.admin? } do
    namespace :admin do
      root to: redirect('admin/mockups')
      resources :mockups, only: [:index]
    end
  end
end
