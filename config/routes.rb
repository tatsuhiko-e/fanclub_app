Rails.application.routes.draw do
  get 'events/index'
  get 'events/new'
  get 'events/create'
  get 'events/edit'
  get 'events/update'
  get 'events/destroy'
  get 'relationships/create'
  get 'relationships/destroy'
  root to: 'home#about'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  devise_scope :user do
    get '/users/sign_out', to: 'devise/sessions#destroy'
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: "/letter_opener"
  end

  resources :users do
    member do
      get :followings
      get :followers
    end
    resources :members
    resources :posts do
      resources :likes, only: [:create]
      resource :like, only: [:destroy]
      resources :comments, only: [:create, :destroy]
    end
    resources :events
    resources :videos
  end

  resources :relationships, only: [:create, :destroy]

  
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/about', to: 'home#about'
  get '/makefanclub', to: 'home#makefanclub'
  
end
