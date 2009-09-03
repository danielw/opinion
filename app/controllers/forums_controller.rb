class ForumsController < ApplicationController
  before_filter :require_super_user, :except => [:show]


  def show
    @forum = Forum.find(params[:id])
    @category_pages = Paginator.new(self, @forum.categories.count(:all, :conditions => access_conditions), 20, params[:page])
    @categories = @forum.categories.find(:all, :limit => 20, :conditions => access_conditions, :offset => @category_pages.current.offset, :order => 'id ASC')    
    
    @rss = forum_url(@forum, :format => 'xml')

    today, yesterday = Time.now.to_date, Time.now.yesterday.to_date     
    @recent_posts = @forum.posts.find(:all, :limit => 20, :conditions => ['category_id in (?)', Category.ids_matching(access_conditions)], :order => 'id DESC')

    respond_to do |accepts|
      accepts.html
      accepts.xml { render :action => 'show.rxml', :layout => false}
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
      accepts.html { flash[:notice] = "Successfully removed..."; redirect_to index_url  }
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


end
