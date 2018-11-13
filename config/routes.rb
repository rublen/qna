Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

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
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
