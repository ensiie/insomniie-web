InsomniieWeb::Application.routes.draw do

  devise_for :users,
    :skip => [:sessions, :registrations],
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" } do
    post 'sign_in' => 'devise/sessions#create', as: :new_user_session
    delete 'sign_out' => 'devise/sessions#destroy', as: :destroy_user_session
  end

  root :to => 'high_voltage/pages#show', :id => 'home'
end
