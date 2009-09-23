require File.dirname(__FILE__) + '/test_helper'

class EngineTest < Test::Unit::TestCase
  
  def setup
    HtmlEngine.default = :textile
  end

  def test_to_html
    assert_equal :textile, HtmlEngine.default
    assert_equal '<p>Hello World</p>',  "Hello World".to_html
  end
  
  def test_simple_formatting
    assert_equal "<p>a\n<br />b</p>\n\n<p>c</p>", "a\nb\n\nc".to_html(:simple)
  end

  def test_autolink
    assert_equal "<p>www.test.com</p>", "www.test.com".to_html(:textile)
    assert_equal "<a href=\"http://www.test.com\">www.test.com</a>", "www.test.com".to_html(:autolink)
  end
  
  def test_sanitize
    assert_equal "<a href=\"http://www.test.com\">www.test.com</a>", "<a href=\"http://www.test.com\" onclick=\"#\">www.test.com</a>".to_html(:sanitize)    
  end
  
  def test_chain
    assert_equal "<p><a href=\"http://www.test.com\"><a href=\"http://www.test.com\">www.test.com</a> <strong>is</strong> cool</a></p>", "<a href=\"http://www.test.com\" onclick=\"#\">www.test.com *is* cool</a>".to_html(:textile, :autolink, :sanitize)    
  end
  
  def test_default_chain
    HtmlEngine.default = [:textile, :autolink, :sanitize]
    assert_equal "<p><a href=\"http://www.test.com\"><a href=\"http://www.test.com\">www.test.com</a> <strong>is</strong> cool</a></p>", "<a href=\"http://www.test.com\" onclick=\"#\">www.test.com *is* cool</a>".to_html
  end
  
  def test_zealous_textile
    assert_equal '<p>liquid: {% test %}</p>', 'liquid: {% test %}'.to_html(:textile)
    assert_equal '<p>liquid: {%test%}</p>', 'liquid: {%test%}'.to_html(:textile)
    assert_equal '<p>liquid: {{ test }}</p>', 'liquid: {{ test }}'.to_html(:textile)
    assert_equal '<p>liquid: <span>test</span></p>', 'liquid: %test% '.to_html(:textile)
  end
  
  def test_mailto_link
    assert_equal "<p>Jesse Storimer Developer &#8211; Shopify jesse@jadedpixel.com</p>", "Jesse Storimer Developer - Shopify jesse@jadedpixel.com".to_html
  end
  
  
end
