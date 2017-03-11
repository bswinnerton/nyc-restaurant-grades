Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/', graphql_path: '/graphql'

  namespace :api do
    namespace :v1 do
      resources :restaurants, only: [:index, :show] do
        resources :inspections, only: [:index, :show] do
          resources :violations, only: [:index, :show]
        end
      end
    end
  end

  post '/graphql' => 'graphql#create'
end
