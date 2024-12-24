module Api
  class TodoListsController < ApplicationController
    before_action :set_resource, only: %i[show]

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
      @todo_list = TodoList.new(params_for_create)

      respond_to do |format|
        format.json do
          @todo_list.save!

          render json: @todo_list
        end
      end
    end

    private

    def set_resource
      @todo_list = TodoList.find(params[:id])
    end

    def params_for_create
      params.require(:todolist).permit(:name)
    end
  end
end
