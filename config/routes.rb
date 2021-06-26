Rails.application.routes.draw do
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
    resources :members
  end

  
  
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/about', to: 'home#about'
  get '/makefanclub', to: 'home#makefanclub'
  
end
