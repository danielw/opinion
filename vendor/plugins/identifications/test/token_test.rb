require File.dirname(__FILE__) + '/test_helper'

class TokenTest < Test::Unit::TestCase
  fixtures :articles, :secret_articles

  def test_truth
    assert true
  end
  
  def test_token 
    assert_match /^[a-f0-9]{32}$/, Article.create( 'title' => 'whatever').token
  end

  def test_multiple_saves 
    article = Article.create( 'title' => 'whatever')
    token = article.token
    assert_match /^[a-f0-9]{32}$/, token

    assert article.save
    assert article.save
    
    assert_equal token,  article.token    
  end
  
  def test_truncated_token
    assert_match /^[a-f0-9]{10}$/, SecretArticle.create( 'title' => 'whatever').token
  end
  
end
