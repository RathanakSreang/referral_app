Rails.application.routes.draw do
  namespace :api, path: "/" do
    namespace :v1 do
      post "signin", to: "auth#signin"
      post "signup", to: "auth#signup"
      delete "signout", to: "auth#signout"
      resources :users, only: [] do
        collection do
          get :my_profile
          resources :referrals, only: [:create, :index]
        end
      end
    end
  end
end
