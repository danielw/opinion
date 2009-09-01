class LegacyRoutesController < ApplicationController

  def area
    area = Forum.find(params[:id])
    redirect_to forum_url(area)
  end

  def category
    cat = Category.find(params[:id])
    redirect_to category_url(cat)
  end
  
  def post
    post = Post.find(params[:id])
    redirect_to category_post_url(post.category_id, post.id)
  end
end
