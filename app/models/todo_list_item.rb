class TodoListItem < ApplicationRecord
  belongs_to :todo_list

  validates :text, presence: true, length: { maximum: 255 }
end
