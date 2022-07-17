require "test_helper"

class TodoCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @todo_category = todo_categories(:one)
  end

  test "should get index" do
    get todo_categories_url, as: :json
    assert_response :success
  end

  test "should create todo_category" do
    assert_difference("TodoCategory.count") do
      post todo_categories_url, params: { todo_category: { color: @todo_category.color, title: @todo_category.title } }, as: :json
    end

    assert_response :created
  end

  test "should show todo_category" do
    get todo_category_url(@todo_category), as: :json
    assert_response :success
  end

  test "should update todo_category" do
    patch todo_category_url(@todo_category), params: { todo_category: { color: @todo_category.color, title: @todo_category.title } }, as: :json
    assert_response :success
  end

  test "should destroy todo_category" do
    assert_difference("TodoCategory.count", -1) do
      delete todo_category_url(@todo_category), as: :json
    end

    assert_response :no_content
  end
end
