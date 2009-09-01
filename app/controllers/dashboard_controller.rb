class DashboardController < ApplicationController
  
  def index
    @topic_count = Topic.count
    @comment_count = Comment.count
    @user_count = User.count
    @forums = Forum.find(:all)
    @rss = url_for(:action => 'feed', :only_path => false)

    today, yesterday = Time.now.to_date, Time.now.yesterday.to_date     
    @recent_posts = Post.find(:all, :limit => 10, :conditions => ["category_id in (?)", Category.ids_matching(access_conditions)],  :order => 'id DESC')
  end

  def feed
    @recent_posts = Post.find(:all, :conditions => ["category_id in (?)", Category.ids_matching(access_conditions)], :limit => 10, :order => 'id DESC')
    respond_to do |accepts|
      accepts.xml { render :action => 'feed.rxml', :layout => false}
    end
  end

end
