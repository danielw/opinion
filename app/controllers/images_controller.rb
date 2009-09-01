class ImagesController < ApplicationController
  before_filter :fetch_post
  
  def create
    if @post.editable? and @post.owner?(@user)
      image = @post.images.build(params[:image])
      
      if image.save
        flash[:notice] = "Successfully uploaded #{image.filename}..."
      else
        flash[:error] = "Uploaded image was too large."
      end
    end
    
    params[:return_to] ? redirect_to(params[:return_to]) : redirect_to(:back)
  end
  
  private
  
  def fetch_post
    @post = Category.find(params[:category_id], :conditions => access_conditions).posts.find(params[:post_id])
  end
end
