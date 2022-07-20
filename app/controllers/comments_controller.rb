class CommentsController < ApplicationController
  before_action :set_comment, only: %i[ show update destroy ]
  before_action :set_todo, only: %i[ create ]

  # GET /comments
  def index
    @comments = Comment.all

    render json: @comments
  end

  # GET /comments/1
  def show
    render json: @comment
  end

  # POST /comments
  def create
    commentClone = comment_params.clone
    commentClone[:user] = @current_user.name
    commentClone[:todo] = @todo
    @comment = Comment.new(commentClone)

    if @comment.save
      render json: @comment, status: :created, location: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /comments/1
  def update
    if @comment.update(comment_params)
      render json: @comment
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  # DELETE /comments/1
  def destroy
    @comment.destroy
  end

  private
    def set_todo
      @todo = Todo.where('owner_id': @current_user._id).find { |t|
        tid = { :$oid => params[:id] }
        t[:_id].to_json == tid.to_json
      }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @todo = Todo.where('owner_id': @current_user._id).find { |t|
          tid = { :$oid => params[:id] }
          t[:_id].to_json == tid.to_json
        }
      @comment = @todo.comments.find { |c|
        cid = { :$oid => params[:comment_id] }
        c[:_id].to_json == cid.to_json
      }
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:comment)
    end
end
