require 'test_helper'

class ModelProductCategoriesControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:model_product_categories)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_model_product_category
    assert_difference('ModelProductCategory.count') do
      post :create, :model_product_category => { }
    end

    assert_redirected_to model_product_category_path(assigns(:model_product_category))
  end

  def test_should_show_model_product_category
    get :show, :id => model_product_categories(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => model_product_categories(:one).id
    assert_response :success
  end

  def test_should_update_model_product_category
    put :update, :id => model_product_categories(:one).id, :model_product_category => { }
    assert_redirected_to model_product_category_path(assigns(:model_product_category))
  end

  def test_should_destroy_model_product_category
    assert_difference('ModelProductCategory.count', -1) do
      delete :destroy, :id => model_product_categories(:one).id
    end

    assert_redirected_to model_product_categories_path
  end
end
