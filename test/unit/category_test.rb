require File.dirname(__FILE__) + '/../test_helper'

class CategoryTest < Test::Unit::TestCase
  fixtures :categories

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Category, categories(:first)
  end
end
