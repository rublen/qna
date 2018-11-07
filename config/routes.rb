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

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable], except: %i[index new show] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy

  mount ActionCable.server => '/cable'
end
