require File.dirname(__FILE__) + '/../test_helper'
require 'users_controller'

# Re-raise errors caught by the controller.
class UsersController; def rescue_action(e) raise e end; end

class UsersControllerTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @controller = UsersController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_show_valid
    get :show, :id => 1
    assert_tag
  end
  
  def test_userlist_valid
    get :list
    assert_tag
  end
  
  def test_gravatar_valid
    get :gravatar
    assert_tag
  end
  
end
