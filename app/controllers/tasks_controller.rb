class TasksController < ApplicationController
  before_action :set_task, only: %i[ show update destroy ]
  before_action :set_todo, only: %i[ create ]

  # GET /tasks
  def index
    @tasks = Task.all

    render json: @tasks
  end

  # GET /tasks/1
  def show
    render json: @task
  end

  # POST /todos/1/tasks
  def create
    taskClone = task_params.clone
    taskClone[:status] = "WAITING"
    taskClone[:todo] = @todo
    @task = Task.new(taskClone)

    if @task.save
      render json: @task, status: :created, location: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /tasks/1
  def update
    if task_params[:status] != "WAITING" && task_params[:status] != "DONE"
      render json: { error: 'Invalid status' }, status: :unprocessable_entity
      return
    end

    if @task.update(task_params)
      render json: @task
    else
      render json: @task.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1/tasks/1
  def destroy
    @task.destroy
  end

  private
    def set_todo
      # @todo = Todo.where('owner_id': @current_user._id).find { |t|
      #   tid = { :$oid => params[:id] }
      #   t[:_id].to_json == tid.to_json
      # }
      @todo = Todo.find(params[:id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_task
      # @todo = Todo.where('owner_id': @current_user._id).find { |t|
      #     tid = { :$oid => params[:id] }
      #     t[:_id].to_json == tid.to_json
      #   }
      @todo = Todo.find(params[:id])
      @task = @todo.tasks.find { |t|
        tid = { :$oid => params[:task_id] }
        t[:_id].to_json == tid.to_json
      }
    end

    # Only allow a list of trusted parameters through.
    def task_params
      params.require(:task).permit(:status, :title)
    end
end
