module Api
  class TodoListsController < ApiController
    before_action :set_resource, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      render json: @todo_lists
    end

    # GET /api/todolists/:id
    def show
      render json: @todo_list
    end

    # POST /api/todolists
    def create
      @todo_list = TodoList.new(required_params)
      @todo_list.save!

      render json: @todo_list
    end

    # PUT|PATCH /api/todolist/:id
    def update
      @todo_list.update!(required_params)

      render json: @todo_list
    end

    # DELETE /api/todolist/:id
    def destroy
      @todo_list.destroy!

      head :no_content
    end

    private

    def set_resource
      @todo_list = TodoList.find(params[:id])
    end

    def required_params
      params.require(:todolist).permit(:name)
    end
  end
end
