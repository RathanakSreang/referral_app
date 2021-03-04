Rails.application.routes.draw do
  namespace :api, path: "/" do
    namespace :v1 do
      post "signin", to: "auth#signin"
      post "signup", to: "auth#signup"
      delete "signout", to: "auth#signout"
      resources :users
    end
  end
end
