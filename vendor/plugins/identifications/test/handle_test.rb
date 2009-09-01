require File.dirname(__FILE__) + '/test_helper'

class HandleTest < Test::Unit::TestCase
  fixtures :posts

  def test_truth
    assert true
  end
  
  def test_sql
    ActiveRecord::Base.connection.execute("INSERT INTO posts (handle) VALUES ('test')")
    ActiveRecord::Base.connection.execute("INSERT INTO posts (handle) VALUES ('test-1')")
    ActiveRecord::Base.connection.execute("INSERT INTO posts (handle) VALUES ('test-2')")
    assert_equal '3', ActiveRecord::Base.connection.select_value("SELECT count(id) FROM posts WHERE handle LIKE 'test%'")
  end
  
  def test_create_new
    post = Post.create(:title => 'hi there', :shop_id => 1)
    assert_equal post.handle, 'hi-there'
  end
  
  def test_transformation_end
    
    assert_equal 'hello-there-people', Post.create(:title => 'HELLO THERE PEOPLE!!!', :shop_id => 1).handle
    assert_equal 'hello-there-people-1', Post.create(:title => '!!!!HELLO THERE PEOPLE!!!', :shop_id => 1).handle
    assert_equal 'hello-there-people-2', Post.create(:title => 'HELLO tHeRe   PEoPLE', :shop_id => 1).handle
    
  end
  
  def test_coninue_the_count
    
    assert_equal 'testing-12345', Post.create(:title => 'Testing 12345', :shop_id => 1).handle
    assert_equal 'testing-12346', Post.create(:title => 'Testing 12345', :shop_id => 1).handle
    
  end
  
  def test_continue_count_no_whitespace
    assert_equal 'testing12345', Post.create(:title => 'Testing12345', :shop_id => 1).handle
    assert_equal 'testing12346', Post.create(:title => 'Testing12345', :shop_id => 1).handle    
  end
  
  def test_collisions
    # hello-world exists already.. so it should be inced..
    assert_equal 'hello-world-1', Post.create(:title => 'Hello World', :shop_id => 1).handle

    # hello-world-2 exists already.. so it should be inced..
    assert_equal 'hello-world-3', Post.create(:title => 'Hello World', :shop_id => 1).handle
    assert_equal 'hello-world-4', Post.create(:title => 'Hello World', :shop_id => 1).handle    
  end
  
  def test_multipe_saves
    post = Post.new(:title => 'Hello', :shop_id => 1)
    assert post.save
    assert_equal 'hello', post.handle
    assert post.save
    assert_equal 'hello', post.handle
  end
  
  def test_handle_with_from_specified
    a = StrangeArticle.new(:name => 'Hello')
    assert a.save
    assert_equal 'hello', a.handle
  end
end
