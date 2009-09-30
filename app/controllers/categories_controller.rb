class CategoriesController < ApplicationController
  before_filter :require_admin, :except => [:show]
  
  def show
    @category = Category.find(params[:id], :conditions => access_conditions)
    @topics = @category.topics.paginate(:all, :per_page => 20, :page => params[:page], :order => "(status = 'sticky') DESC, updated_at DESC")  
    @recent_posts = @category.posts.find(:all, :limit => 20, :order => 'id DESC')
    @rss = category_url(@category, :format => 'xml')
    
    respond_to do |accepts|
      accepts.html
      accepts.xml { render :action => 'show.rxml', :layout => false}
    end    
  end
  
  def create
    forum = Forum.find(params[:forum_id])
    @categories = forum.categories
    @category = Category.new
    @category.forum_id = forum.id
    @category.attributes = params[:category]
    @category.save
    
    respond_to do |accepts|
      accepts.js
    end
  end
  
  def edit
    @category = Category.find(params[:id])
    render :partial => 'edit'
  end
  
  def destroy
    @category = Category.find(params[:id])
    @category.destroy
  end
  
  def rename
    update
    @categories = @category.forum.categories
  end
  
  def update
    @category = Category.find(params[:id])
    @category.attributes = params[:category]
    @category.save
  end

  private
  
  

end
