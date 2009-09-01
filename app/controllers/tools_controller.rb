class ToolsController < ApplicationController
  skip_before_filter :login

  def preview_textile
    render :text => request.raw_post.to_html
  end

end
