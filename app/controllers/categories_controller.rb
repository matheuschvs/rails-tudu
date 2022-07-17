class CategoriesController < ApplicationController
  before_action :set_category, only: %i[ show update destroy ]

  # GET /categories
  def index
    @categories = @current_user.categories

    render json: @categories
  end

  # GET /categories/1
  def show
    render json: @category
  end

  # POST /categories
  def create
    paramsAndUser = category_params.clone
    paramsAndUser[:user] = @current_user
    @category = Category.new(paramsAndUser)

    if @category.save
      render json: @category, status: :created, location: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /categories/1
  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # DELETE /categories/1
  def destroy
    @category.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_category
      @category = @current_user.categories.find { |c|
        cid = { :$oid => params[:id] }
        c[:_id].to_json == cid.to_json
      }
    end

    # Only allow a list of trusted parameters through.
    def category_params
      params.require(:category).permit(:title, :color)
    end
end
