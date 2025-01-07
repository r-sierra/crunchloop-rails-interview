module Api
  class TodoListItemsController < ApiController
    before_action :set_resource, only: %i[show update destroy]

    # GET /api/todolist/:todo_list_id/items
    def index
      @todo_items = TodoList.find(params[:todo_list_id]).items
    end

    # GET /api/todolist/:todo_list_id/items/:id
    def show; end

    # POST /api/todolist/:todo_list_id/items
    def create
      @todo_item = TodoList.find(params[:todo_list_id])
        .items.build(required_params)
      @todo_item.save!

      render :show
    end

    # PUT|PATCH /api/todolist/:todo_list_id/items/:id
    def update
      @todo_item.update!(required_params)

      render :show
    end

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

    def required_params
      params.require(:item).permit(:text)
    end
  end
end
