Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, path: :todolists do
      resources :todo_list_items, only: %i[show], path: :items
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
