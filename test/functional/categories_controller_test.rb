require File.dirname(__FILE__) + '/../test_helper'
require 'categories_controller'

# Re-raise errors caught by the controller.
class CategoriesController; def rescue_action(e) raise e end; end

class CategoriesControllerTest < Test::Unit::TestCase
  fixtures :forums, :categories, :users

  def setup
    @controller = CategoriesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = {:user => users(:admin_hans)}    
  end

  def test_show_valid
    get :show, :id => 1
    assert_tag
  end
  
  def test_show_secret_with_access
    get :show, :id => 3
    assert_tag
  end
  
  def test_show_secret_without_access
    @request.session = {:user => users(:max)}    
    
    assert_raise(ActiveRecord::RecordNotFound) do
      get :show, :id => 3
    end
  end
  
  
  def test_create
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Category.count
    post :create, :category => { :title => "Holzschuh" }, :forum_id => 1
    assert_response :success
    assert_template "create", @response.body
    assert_equal "Holzschuh", Category.find(:all).last.title
    assert_equal count + 1, Category.count
  end
  
  def test_create_without_credentials
    @request.session = {:user => users(:max)}    
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Category.count
    post :create, :category => { :title => "Holzschuh" }, :forum_id => 1
    assert_response :redirect
    assert_redirected_to index_url
    assert_equal count, Category.count
  end
  
  def test_update
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    post :update, :id => 1, :category => { :title => "A whole new mind" }
    assert_response :success
    assert_template "update", @response.body
    assert_equal "A whole new mind", Category.find(1).title    
  end
  
  def test_destroy
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Category.count
    post :destroy, :id => 1
    assert_response :success
    assert_template "destroy", @response.body
    assert_equal count - 1, Category.count
  end
  
end
