class TodoList < ApplicationRecord
  has_many :items, class_name: 'TodoListItem', dependent: :destroy

  validates :name, presence: true
end
