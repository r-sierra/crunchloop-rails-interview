Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index show create update], path: :todolists
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
