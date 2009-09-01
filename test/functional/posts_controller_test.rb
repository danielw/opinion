require File.dirname(__FILE__) + '/../test_helper'
require 'posts_controller'

# Re-raise errors caught by the controller.
class PostsController; def rescue_action(e) raise e end; end

class PostsControllerTest < Test::Unit::TestCase
  fixtures :forums, :categories, :posts, :users

  def setup
    @controller = PostsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new

    @request.session = {:user => users(:admin_hans)} 
  end

  def test_show_valid
    get :show, :category_id => 1, :id => 1
    assert_tag
  end
  
  def test_new_valid
    get :new, :category_id => 1
    assert_tag
  end

  def test_edit_valid
    get :edit, :category_id => 1, :id => 1
    assert_tag
  end
  
  def test_show_secret_with_access
    get :show, :category_id => 3, :id => 4
    assert_tag
  end
  
  def test_show_secret_without_access
    @request.session = {:user => users(:max)}    
    
    assert_raise(ActiveRecord::RecordNotFound) do
      get :show, :category_id => 3, :id => 4
    end
  end
  

  def test_update_status
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    post = posts(:first)
    assert_equal 'normal', post.status    
    put :update, :category_id => 1, :id => 1, :post => { :status => 'sticky' }

    assert_equal "Flash.notice(\"Topic status set to: \\u003Cu\\u003Esticky\\u003C/u\\u003E\");", @response.body    
    assert_equal 'sticky', post.reload.status
  end

  def test_create_new_topic
    count = Post.count
    post :create, :category_id => 1, :topic => { :title => "Yadayada", :body => "A horse is a horse of course of course and no one would talk to a horse of course."}, :commit => "Create"
    assert_response :redirect
    assert_redirected_to :controller => 'posts', :action => 'show', :id => Post.find(:all).last
    assert_equal count + 1, Post.count
  end
  
  def test_create_topic_without_title    
    count = Post.count
    post :create, :category_id => 1, :topic => { :body => "A horse is a horse of course of course and no one would talk to a horse of course."}, :commit => "Create"
    assert_response :redirect
    assert_equal count + 1, Post.count
    assert 'untitled', Post.find(:all).last.title
  end
  
  def test_create_comment
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Post.count
    post :create, :category_id => 1, :comment => { :body => "I object!"}, :topic => 1, :commit => "Create"
    assert_response :redirect
    assert_equal count + 1, Post.count    
  end
  
  def test_create_comment_for_different_category
    @request.env["HTTP_ACCEPT"] = "text/javascript"
    count = Post.count
    post :create, :category_id => 2, :comment => { :body => "I object!"}, :topic => 3, :commit => "Create"
    assert_response :redirect
    last_comment = Post.find(:all).last
    assert_equal 2, last_comment.category.id
    assert_equal 3, last_comment.topic.id
    assert_equal count + 1, Post.count    
  end
  
  def test_spam_protection
    @request.session = {:user => nil} 
    count = Post.count
    post :create, :category_id => 1, :verify => {:spam => true, :nospam => true}, :comment => { :body => "Go find me some phentodextermine and v14gra."}, :topic => 1, :commit => "Create"
    assert_response 403
    assert_equal 'I am afraid I did not save your comment due to you are suspicously resembling a spambot being!', @response.body
    assert_equal count, Post.count    
  end

  def test_spam_protection_w_different_params
    @request.session = {:user => nil} 
    count = Post.count
    post :create, :category_id => 1, :verify => {:spam => false, :nospam => false}, :comment => { :body => "Go find me some phentodextermine and v14gra."}, :topic => 1, :commit => "Create"
    assert_response 403
    assert_equal 'I am afraid I did not save your comment due to you are suspicously resembling a spambot being!', @response.body
    assert_equal count, Post.count    
  end

  def test_spam_protection_w_different_params_2
    @request.session = {:user => nil} 
    count = Post.count
    post :create, :category_id => 1, :verify => {:spam => true, :nospam => false}, :comment => { :body => "Go find me some phentodextermine and v14gra."}, :topic => 1, :commit => "Create"
    assert_response 403
    assert_equal 'I am afraid I did not save your comment due to you are suspicously resembling a spambot being!', @response.body
    assert_equal count, Post.count    
  end
  
  def test_destroy
    @request.env["HTTP_ACCEPT"] = "text/javascript"    
    count = Post.count
    post :destroy, :category_id => 1, :id => 2
    assert_response :redirect
    assert_equal count -1, Post.count
  end

end
