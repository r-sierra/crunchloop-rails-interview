Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, only: %i[index show create], path: :todolists
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
