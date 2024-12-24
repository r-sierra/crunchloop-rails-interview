module Api
  class TodoListsController < ApplicationController
    before_action :set_resource, only: %i[show update]

    # GET /api/todolists
    def index
      @todo_lists = TodoList.all

      respond_to :json
    end

    # GET /api/todolists/:id
    def show
      respond_to :json
    end

    # POST /api/todolists
    def create
      @todo_list = TodoList.new(required_params)

      respond_to do |format|
        format.json do
          @todo_list.save!

          render json: @todo_list
        end
      end
    end

    # PUT|PATCH /api/todolist/:id
    def update
      respond_to do |format|
        format.json do
          @todo_list.update!(required_params)

          render json: @todo_list
        end
      end
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
