Rails.application.routes.draw do
  root to: 'questions#index'

  devise_for :users

  resources :questions do
    # resources :votes, only: %i[up down unvote] do
    #   collection do
    #     post :up
    #     post :down
    #   end
    #   delete :unvote, on: :member
    # end

    resources :answers, shallow: true, except: %i[index new show] do
      patch :best, on: :member

      # resources :votes, only: %i[up down unvote] do
      #   collection do
      #     post :up
      #     post :down
      #   end
      #   delete :unvote, on: :member
      # end
    end
  end

  resources :attachments, only: :destroy

  resources :votes, only: %i[up down unvote] do
    collection do
      post :up
      post :down
    end
    delete :unvote, on: :member
  end
end
