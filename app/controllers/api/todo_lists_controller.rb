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

    private

    def set_resource
      @todo_list = TodoList.find(params[:id])
    end
  end
end
