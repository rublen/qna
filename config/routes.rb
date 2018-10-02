Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    resources :answers, shallow: true, except: %i[index new show] do
      get 'best', on: :member
    end
  end

end
