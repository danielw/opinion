class ForumsController < ApplicationController
  before_filter :require_super_user, :except => [:show, :index, :recent_activity]
  
  def index
    @forum = Forum.find(:all).first

    @recent_posts = @forum.posts.find(:all, :limit => 10, :conditions => ['category_id in (?)', Category.ids_matching(access_conditions)], :order => 'id DESC')
    respond_to do |accepts|
      accepts.html do
        @categories = @forum.categories.paginate(:all, :limit => 20, :conditions => access_conditions, :page => params[:page], :order => 'id ASC')    
        render :action => :show
      end
      accepts.xml do
        @rss = forum_url(@forum, :format => 'xml')
        render :action => 'show.rxml', :layout => false
      end
    end    
  end


  def create
    @forum = Forum.new
    @forum.attributes = params[:forum]
    @forum.save
    
    respond_to do |accepts|
      accepts.html { flash[:notice] = "Successfully created..."; redirect_to forum_url(@forum)  }
      accepts.js   
    end
  end
  
  def destroy
    @forum = Forum.find(params[:id])
    @forum.destroy

    respond_to do |accepts|
      accepts.html { flash[:notice] = "Successfully removed..."; redirect_to root_url  }
      accepts.js   
    end
  end
  
  def update
    @forum = Forum.find(params[:id])
    @forum.attributes = params[:forum]
    @forum.save
    
    respond_to do |accepts|
      accepts.html { flash[:notice] = "Successfully updated..."; redirect_to forum_url(@forum)  }
      accepts.js   
    end
  end

  def recent_activity
    @forum = Forum.find(:all).first

    @recent_posts = @forum.posts.find(:all, :limit => 30, :conditions => ['category_id in (?)', Category.ids_matching(access_conditions)], :order => 'id DESC')    
  end


end
