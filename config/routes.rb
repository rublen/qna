Rails.application.routes.draw do

  root to: 'questions#index'

  use_doorkeeper

  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    resources :users, controller: 'omniauth_callbacks' do
      get :oauth_enter_email, on: :collection
      patch :oauth_update_email, on: :member
    end
  end

  concern :votable do
    resources :votes, shallow: true, only: %i[up down unvote] do
      collection do
        post :up
        post :down
      end
      delete :unvote, on: :member
    end
  end

  concern :commentable do
    resources :comments, shallow: true, only: %i[create destroy] do
      post :create, on: :collection
      delete :destroy, on: :member
    end
  end

  resources :questions, concerns: [:votable, :commentable] do
    resources :answers, shallow: true, concerns: [:votable, :commentable], except: %i[index new show] do
      patch :best, on: :member
    end

    resources :subscriptions, shallow: true, only: [:create, :destroy]
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      resource :profiles, only: %i[index me] do
        get :me, on: :collection
        get :index, on: :collection
      end
      resources :questions, only: %i[index show create] do
        resources :answers, shallow: true, only: %i[index show create]
      end
    end
  end
end
