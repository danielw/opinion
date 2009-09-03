require File.dirname(__FILE__) + '/../test_helper'

class UserTest < ActiveSupport::TestCase
  def test_truth
    assert_kind_of User, users(:admin_hans)
  end
end
