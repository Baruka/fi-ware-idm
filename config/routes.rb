FiWareIdm::Application.routes.draw do
  # FI-WARE compatible routes
  match '/authorize', to: 'authorizations#new'
  post  '/token', to: proc { |env| SocialStream::Oauth2Server::TokenEndpoint.new.call(env) }

  devise_for :users, :controllers => {:omniauth_callbacks => 'omniauth_callbacks', registrations: 'user_registrations', sessions: 'user_sessions'}
  
  namespace :permission do
    resources :customs
  end

  resources :purchases
  resources :external_idps
  resources :external_sps
  
  #SCIM 2.0 API
  namespace :v2 do
    resources :users
    resources :organizations
    match '/ServiceProviderConfigs' => "base#getConfig"
    match '/testing' => "base#testing"
  end

  match '/terms-of-service' => 'frontpage#terms_of_service', as: :terms_of_service
end
