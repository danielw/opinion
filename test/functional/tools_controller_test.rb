require File.dirname(__FILE__) + '/../test_helper'
require 'tools_controller'

# Re-raise errors caught by the controller.
class ToolsController; def rescue_action(e) raise e end; end

class ToolsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ToolsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    @request.env["HTTP_ACCEPT"] = "text/javascript"
  end

  def test_preview_textile
    @request.env['RAW_POST_DATA'] = "I am a *bold*\n\ntwo paragraph phrase."
    get :preview_textile
    assert_equal "<p>I am a <strong>bold</strong></p>\n\n\n\t<p>two paragraph phrase.</p>", @response.body
  end

end
