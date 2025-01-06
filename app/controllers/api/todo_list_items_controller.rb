module Api
  class TodoListItemsController < ApiController
    before_action :set_resource, only: %i[show destroy]

    # GET /api/todolist/:todo_list_id/items/:id
    def show; end

    # DELETE /api/todolist/:todo_list_id/items/:id
    def destroy
      @todo_item.destroy!

      head :no_content
    end

    private

    def set_resource
      @todo_list = TodoList.find(params[:todo_list_id])
      @todo_item = @todo_list.items.find(params[:id])
    end
  end
end
