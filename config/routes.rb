Rails.application.routes.draw do
  #el usuario no creara tokens de forma directa
  #resources :tokens
  devise_for :users
  #devise_for :users
  scope "(:locale)", locale: /es|en/ do
   namespace :api, :defaults => { format: :json } do
      namespace :v1 do
        resources :users do
          collection do
            post 'login'
          end
        end
        root 'home#index'
        get 'home/index'
      end
    end
  end
end
# For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
