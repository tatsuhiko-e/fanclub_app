Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
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
      get :email_edit, as: 'edit_email'
      get :followings
      get :followers
      get :posts
      get :events
      get :videos
      get :contacts
      get :contact_mails
    end
  end

  resources :members
  resources :videos
  resources :posts do
    resources :likes, only: [:create]
    resource :like, only: [:destroy]
    resources :comments, only: [:create, :destroy]
  end
  resources :events do
    resources :tickets, only: [:create]
    resource :ticket, only: [:destroy]
    member do
      get :ticket_users
      get :day
    end
  end
  resources :adminrequests, only: [:new, :create]
  post 'adminrequests/confirm', to: 'adminrequests#confirm', as: 'confirm'
  post 'adminrequests/back', to: 'adminrequests#back', as: 'back'
  get 'done', to: 'adminrequests#done', as: 'done'

  resources :contacts, only: [:new, :create, :show]
  post 'contacts/confirm', to: 'contacts#confirm'
  post 'contacts/back', to: 'contacts#back'
  get 'mail_done', to: 'contacts#mail_done'

  resources :messages, only: [:create]
  resources :rooms, only: [:create, :show, :index]
  resources :relationships, only: [:create, :destroy]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/about', to: 'home#about'
  get '/makefanclub', to: 'home#makefanclub'
end
