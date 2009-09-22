require 'test_helper'

class SearchControllerTest < ActionController::TestCase

  def test_posts_valid
    get :posts, 'q' => "test"
    assert_tag
  end
  
end
