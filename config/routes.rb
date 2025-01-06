Rails.application.routes.draw do
  namespace :api do
    resources :todo_lists, path: :todolists do
      resources :todo_list_items, only: %i[show destroy create update], path: :items
    end
  end

  resources :todo_lists, only: %i[index new], path: :todolists
end
