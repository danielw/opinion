require File.dirname(__FILE__) + '/../test_helper'
require 'forums_controller'

# Re-raise errors caught by the controller.
class ForumsController; def rescue_action(e) raise e end; end

class ForumsControllerTest < ActionController::TestCase
  def setup
    @controller = ForumsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.session = {:user => users(:admin_hans)}    
  end

  def test_show_valid
    get :show, :id => 1
    assert_response :ok
  end

  def test_create_new_forum
    count = Forum.count
    post :create, :forum => { :title => "Shiny new forum"}
    assert_response :redirect
    assert_redirected_to :controller => 'forums', :action => 'show', :id => Forum.find(:all).last
    assert_equal count + 1, Forum.count
  end
  
  def test_create_forum_via_js
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Forum.count
    post :create, :forum => { :title => "Shiny new forum"}
    assert_response :success
    assert_template "create", @response.body
    assert_equal count + 1, Forum.count
  end

  def test_create_without_credentials
    @request.session = {:user => users(:max)}    
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Forum.count
    post :create, :forum => { :title => "Shiny new forum"}
    assert_response :redirect
    assert_redirected_to root_url
    assert_equal count, Forum.count
  end

  def test_destroy
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Forum.count
    post :destroy, :id => 1
    assert_response :success
    assert_template "destroy", @response.body
    assert_equal count - 1, Forum.count    
  end
  
  def test_update
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Forum.count
    post :update, :id => 1, :forum => { :title => "LaDiDa"}
    assert_response :success
    assert_template "update", @response.body
    assert_equal "LaDiDa", Forum.find(1).title
    assert_equal count, Forum.count    
  end

end
