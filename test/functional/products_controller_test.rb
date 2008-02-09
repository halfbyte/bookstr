require File.dirname(__FILE__) + '/../test_helper'
require 'products_controller'

# Re-raise errors caught by the controller.
class ProductsController; def rescue_action(e) raise e end; end

class ProductsControllerTest < Test::Unit::TestCase
  fixtures :products

  def setup
    @controller = ProductsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:products)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_product
    # TODO: Mock ECS
    
    old_count = Product.count
    post :create, :product => { :product_code => '978-3827324917' }
    assert_equal old_count+1, Product.count
    
    assert_redirected_to product_path(assigns(:product))
  end

  def test_should_show_product
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_product
    put :update, :id => 1, :product => { }
    assert_redirected_to product_path(assigns(:product))
  end
  
  def test_should_destroy_product
    old_count = Product.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Product.count
    
    assert_redirected_to products_path
  end
end
