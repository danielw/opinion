require File.dirname(__FILE__) + '/../test_helper'

class PostTest < ActiveSupport::TestCase
  def test_create
    assert_difference 'Post.count' do
      Post.create(:body => "lorem ipsum")
    end
  end
  
  def test_script_tags
    assert_difference 'Post.count' do
      @post = Post.new(:title => "Tag Test", :body => "<script>alert('hi')</script>")
      @post.save
    end
    
    assert_equal "Tag Test", @post.title
    assert_equal "&lt;script&gt;alert('hi')&lt;/script&gt;", @post.body_html
  end
  

  def test_pre_tag_will_not_be_automatically_html_escaped
    assert_difference('Post.count', +1) do
      @post = Post.new(:title => "Tag Test", :body => "<p><pre><anytag>text</anytag></pre></p>")
      @post.save
    end
    
    assert_equal "Tag Test", @post.title
    assert_equal "<p><pre>&lt;anytag&gt;text&lt;/anytag&gt;</pre></p>", @post.body_html 
  end

  def test_surrounded_tags
    assert_difference 'Post.count' do
      @post = Post.new(:title => "Tag Test", :body => "<script>alert('hi')</script><pre><anytag>text</anytag></pre><script>alert('hi')</script>")
      @post.save
    end
    
    assert_equal "Tag Test", @post.title 
    assert_equal "&lt;script&gt;alert('hi')&lt;/script&gt;<pre>&lt;anytag&gt;text&lt;/anytag&gt;</pre>&lt;script&gt;alert('hi')&lt;/script&gt;", @post.body_html 
  end


  
end