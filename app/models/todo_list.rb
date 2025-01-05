class TodoList < ApplicationRecord
  has_many :todo_list_item, dependent: :destroy

  validates :name, presence: true
end
