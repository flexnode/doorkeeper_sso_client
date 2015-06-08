DoorkeeperSsoClient::Engine.routes.draw do
  resources :callbacks, :only => [:create]
end
