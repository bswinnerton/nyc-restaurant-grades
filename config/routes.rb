Rails.application.routes.draw do
  mount GraphiQL::Rails::Engine, at: '/', graphql_path: '/graphql'
end
