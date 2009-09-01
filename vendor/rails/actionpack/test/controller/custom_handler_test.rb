require 'abstract_unit'

class CustomHandler < ActionView::TemplateHandler
  def initialize( view )
    @view = view
  end

  def render( template, local_assigns )
    [ template,
      local_assigns,
      @view ]
  end
end

class CustomHandlerTest < Test::Unit::TestCase
  def setup
    ActionView::Base.register_template_handler "foo", CustomHandler
    ActionView::Base.register_template_handler :foo2, CustomHandler
    @view = ActionView::Base.new
  end

  def test_custom_render
    template = ActionView::Template.new(@view, "hello <%= one %>", false, { :one => "two" }, true, "foo")

    result = @view.render_template(template)
    assert_equal(
      [ "hello <%= one %>", { :one => "two" }, @view ],
      result )
  end

  def test_custom_render2
    template = ActionView::Template.new(@view, "hello <%= one %>", false, { :one => "two" }, true, "foo2")
    result = @view.render_template(template)
    assert_equal(
      [ "hello <%= one %>", { :one => "two" }, @view ],
      result )
  end

  def test_unhandled_extension
    # uses the ERb handler by default if the extension isn't recognized
    template = ActionView::Template.new(@view, "hello <%= one %>", false, { :one => "two" }, true, "bar")
    result = @view.render_template(template)
    assert_equal "hello two", result
  end
end
