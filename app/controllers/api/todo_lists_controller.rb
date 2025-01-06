module Api
  class TodoListsController < ApiController
    before_action :set_resource, only: %i[show update destroy]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all
    end

    # GET /api/todolists/:id
    def show; end

    # POST /api/todolists
    def create
      @todo_list = TodoList.new(required_params)
      @todo_list.save!

      render :show
    end

    # PUT|PATCH /api/todolist/:id
    def update
      @todo_list.update!(required_params)

      render :show
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
