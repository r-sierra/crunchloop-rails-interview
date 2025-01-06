module Api
  class TodoListItemsController < ApiController
    before_action :set_resource, only: %i[show]

    def show; end

    private

    def set_resource
      @todo_list = TodoList.find(params[:todo_list_id])
      @todo_item = @todo_list.items.find(params[:id])
    end
  end
end
