InsomniieWeb::Application.routes.draw do

  root :to => 'high_voltage/pages#show', :id => 'home'

  devise_for :users,
    :skip => [:sessions, :registrations],
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    post 'sign_in' => 'devise/sessions#create', as: :new_user_session
    delete 'sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
    post 'theme' => 'users/settings#change_theme'
  end

  resource :journey

  namespace :api do
    namespace :v1, format: :json do
      resource :journey
      namespace :cities do
        get "autocomplete", action: "autocomplete"
        get "region", action: "region"
      end
      namespace :venues do
        get "wikipedia", action: "wikipedia"
      end
    end
  end
end
