require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  def test_truth
    assert_kind_of Category, categories(:first)
  end
end
