class CreateTodoListItems < ActiveRecord::Migration[7.0]
  def change
    create_table :todo_list_items do |t|
      t.belongs_to :todo_list, null: false, foreign_key: true
      t.string :text, limit: 255, null: false

      t.timestamps
    end
  end
end
