class TodosController < ApplicationController
  before_action :set_todo, only: %i[ show add_member destroy_member update destroy ]

  # GET /todos
  def index
    owned_todos = Todo.where('owner_id': @current_user._id).includes(:category)
    member_todos = Todo.all.select { |t|  
      t.member_ids.any? { |m|
        m == @current_user._id
      }
    }

    @todos = owned_todos + member_todos
    render json: @todos
  end

  # GET /todos/1
  def show
    render json: @todo
  end

  # POST /todos/1/members
  def add_member
    member = User.find(params[:member_id])
    new_members = @todo.member_ids.push member._id
    category = @current_user.categories.find { |c|
      c[:_id].to_json == @todo.category_id.to_json
    }

    if @todo.update_attributes(
      member_ids: new_members,
      category: category
    )
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1/members/1
  def destroy_member
    member = @todo.member_ids.find { |m|
      mid = { :$oid => params[:member_id] }
      m.to_json == mid.to_json
    }
    category = @current_user.categories.find { |c|
      c[:_id].to_json == @todo.category_id.to_json
    }
    @todo.member_ids.delete member

    if @todo.update_attributes(
      member_ids: @todo.member_ids,
      category: category
    )
      render json: {}, status: :no_content
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # POST /todos
  def create
    if !unique_title?
      render json: { error: 'Duplicate title' }, status: :unprocessable_entity
      return
    end

    if !valid_category?
      render json: { error: 'Category not found' }, status: :unprocessable_entity
      return
    end

    todoClone = todo_params.clone
    todoClone[:status] = "WAITING"
    todoClone[:category] = @category
    todoClone[:owner] = @current_user
    @todo = Todo.new(todoClone)

    if @todo.save
      render json: @todo, status: :created, location: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /todos/1
  def update
    if !unique_title?
      render json: { error: 'Duplicate title' }, status: :unprocessable_entity
      return
    end

    if todo_params[:category] && !valid_category?
      render json: { error: 'Category not found' }, status: :unprocessable_entity
      return
    end

    if todo_params[:status] != "WAITING" && todo_params[:status] != "DONE"
      render json: { error: 'Invalid status' }, status: :unprocessable_entity
      return
    end

    category = @current_user.categories.find { |c|
      c[:_id].to_json == @todo.category_id.to_json
    }

    if @todo.update({category: category, **todo_params})
      render json: @todo
    else
      render json: @todo.errors, status: :unprocessable_entity
    end
  end

  # DELETE /todos/1
  def destroy
    @todo.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_todo
      @todo = Todo.where('owner_id': @current_user._id).find { |t|
        tid = { :$oid => params[:id] }
        t[:_id].to_json == tid.to_json
    }
    end

    # Only allow a list of trusted parameters through.
    def todo_params
      params.require(:todo).permit(:status, :category, :title, :description, :deadline)
    end

    def unique_title?
      todo = Todo.where('owner_id': @current_user._id)
        .and('title': todo_params[:title])
        .first

      !todo
    end

    def valid_category?
      @category = @current_user.categories.find { |c|
        cid = { :$oid => todo_params[:category] }
        c[:_id].to_json == cid.to_json
      }

      !!@category
    end
end
