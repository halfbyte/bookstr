require File.dirname(__FILE__) + '/../test_helper'
require 'authors_controller'

# Re-raise errors caught by the controller.
class AuthorsController; def rescue_action(e) raise e end; end

class AuthorsControllerTest < Test::Unit::TestCase
  fixtures :authors

  def setup
    @controller = AuthorsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert assigns(:authors)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
  
  def test_should_create_author
    old_count = Author.count
    post :create, :author => { }
    assert_equal old_count+1, Author.count
    
    assert_redirected_to author_path(assigns(:author))
  end

  def test_should_show_author
    get :show, :id => 1
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => 1
    assert_response :success
  end
  
  def test_should_update_author
    put :update, :id => 1, :author => { }
    assert_redirected_to author_path(assigns(:author))
  end
  
  def test_should_destroy_author
    old_count = Author.count
    delete :destroy, :id => 1
    assert_equal old_count-1, Author.count
    
    assert_redirected_to authors_path
  end
end
