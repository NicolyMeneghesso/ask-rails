Rails.application.routes.draw do
  scope "(:locale)", locale: /en|pt-BR/ do
    namespace :site do
      get :index
    end

    namespace :api do
      resources :questions, only: [ :index ] do
        get "answers", on: :collection
        get "answer_check", on: :collection, action: :answer_check
      end
      resources :charts, only: [] do
        get "top_subjects", on: :collection
        get "active_users", on: :collection
        get "user_graph_answers", on: :collection
      end
      get "zip_code", to: "zip_code#show"
    end

    namespace :panel do
      get "/", to: "home#index"
      get "home/index" # dashboard

      namespace :admin do
        get :answer, to: "users#answer"

        resources :users do
          get :profile
          collection do # pesquisando dentro da coleção inteira.
            get :search # painel/admin/users/search
          end
        end

        resources :subjects
        get :subject, to: "users#subject"
        resources :questions
      end
    end

    devise_for :users, controllers: {
      passwords: "users/passwords"
    }

    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    root to: "site#index"

    # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
    # Can be used by load balancers and uptime monitors to verify that the app is live.
    get "up" => "rails/health#show", as: :rails_health_check

    # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
    # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
    # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

    # Defines the root path route ("/")
    # root "posts#index"
  end
end
