InsomniieWeb::Application.routes.draw do

  devise_for :users,
    :skip => [:sessions, :registrations],
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    post 'sign_in' => 'devise/sessions#create', as: :new_user_session
    delete 'sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    post 'theme' => 'users/settings#change_theme'
  end

  root :to => 'high_voltage/pages#show', :id => 'home'

  namespace :api do
    namespace :v1, format: :json do
      resource :journey
    end
  end
end
