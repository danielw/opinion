require File.dirname(__FILE__) + '/../test_helper'
require 'accounts_controller'

# Re-raise errors caught by the controller.
class AccountsController; def rescue_action(e) raise e end; end

module ReCaptcha
  module Controller
    def verify_recaptcha(model = nil)
      true
    end
  end
end

class AccountsControllerTest < Test::Unit::TestCase
  fixtures :forums, :users

  def setup
    @controller = AccountsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @forum = forums(:first)
    @request.session = {:user => users(:admin_hans)}     
  end
  
  def test_save_settings
    user = users(:admin_hans)
    assert "Hans Wurst", user.name
    post :update, :user => { :name => 'Hans Schmitz', :email => 'hans@schmitz.de', :url => 'www.schmitz.de' }
    user = users(:admin_hans).reload
    assert "Hans Schmitz", user.name
    assert "hans@schmitz.de", user.email
    assert "www.schmitz.de", user.url
  end
  
  def test_index_valid
    get :index
    assert_tag
  end

  def test_new_valid
    get :new
    assert_tag
  end
  
  def password_recovery
    get :password_recovery
    assert_tag
  end
  
  def test_create_new_user
    count = User.count
    post :create, :user =>{ :name=>"Enlightened One", :password_confirmation=>"cabbal", :url=>"", :password=>"cabbal", :email=>"new@delhi.el"}, :submit => "Create acconut"
    assert_response :redirect
    
    assert_equal count + 1, User.count
  end

  def test_fail_create_user_with_email_already_taken
    count = User.count
    post :create, :user => { :name => 'Kaboom', :email => 'hans@wurst.de', :url => 'www.schmitz.de', :password => 'defjam', :password_confirmation => 'defjam' }, :submit => "Create acconut"
    assert_response :success
    
    assert_template "new"
    assert_equal count, User.count    
  end

  def test_prevent_user_creation_with_different_user_level
    post :create, :user => { :name => 'Cheat0r', :level => 1024, :email => 'h4x@y0.com', :url => 'www.schmitz.de', :password => 'defjam', :password_confirmation => 'defjam' }, :submit => "Create acconut"
    assert_equal 0, User.find(:all).last.level
  end
  
  def test_destroy_user
    count = User.count
    post :destroy, :id => 1
    assert_response :redirect
    assert_equal count -1, User.count
  end

  def test_destroy_user_without_privileges
    @request.session = {:user => users(:max)} 
    count = User.count
    post :destroy, :id => 1
    assert_response :redirect
    assert_equal count, User.count
  end

  
end
