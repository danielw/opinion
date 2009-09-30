class PostsController < ApplicationController
  before_filter :fetch_category
  before_filter :require_moderator, :except => [:show, :edit, :update, :create, :new]

  def show
    @topic = @post = Topic.find(params[:id])
    @rss = category_post_url(@topic.category, @topic, :format => 'xml')
    
    respond_to do |accepts|
      accepts.html
      accepts.xml { render :action => 'show.rxml', :layout => false}
    end
    
  end
  
  def new    
    @topic = @category.topics.create(params[:topic])
  end
  
  def create
    # If post is a comment, find its parent topic
    if params[:comment]
      @topic = Topic.find(params[:topic])
      
      unless @topic.closed?
        @post = @topic.comments.build(params[:comment])
        @post.forum = @topic.forum
        @post.category_id = @topic.category_id

      end
    
    # if post is a topic, create a new topic
    else
      @post = @category.topics.create(params[:topic])

      @post.forum = @category.forum
      @post.status = "normal"
    end 

    if @user
      @post.user = @user
    else
      if spam?
        render :status => 403, :text => 'I am afraid I did not save your comment due to you are suspicously resembling a spambot being!' 
        return 
      end
    end
    
    if @post.save
      
      if params[:image]
        @post.images << Image.create(params[:image])
      end
      

      if @post.is_topic?
        flash[:notice] = "Created topic #{@post.title}" 
        redirect_to category_post_url(@post.category, @post)
      else
        # saving topic to set updated_at to a proper value
        @topic.save if @topic
        flash[:notice] = "Commented on #{@topic.title}"
        redirect_to :controller => 'posts', :action => 'show', :category_id => @post.category_id, :id => @topic, :anchor => "comment-#{@post.id}"
      end
      
    else  

      if @post.is_topic?
        flash[:error] = "Could not create topic: #{@post.errors.to_sentence}"
        @topic = @post; 
        render :action => 'new'
      else
        flash[:error] = "Could not save topic..."
        redirect_to :controller => 'posts', :action => 'show', :category_id => @post.category_id, :id => @topic, :anchor => "comments"
      end    
    end
    
  end
  
  def edit
    @post = Post.find(params[:id])

    # if current user does not have privileges to edit the post:
    redirect_to category_post_url(@post.category, @post.is_topic? ? @post : @post.topic) unless @post.allow_editing_for(@user)
    #redirect_to category_post_url(@post.category, @post) if @post.user != @user
  end
  
  def update
    @post = Post.find(params[:id])
    @post.attributes = params[:post]
    @post.edited_at = Time.now.utc
    #@post.status = params[:status]
    
    if @post.save
      respond_to do |accepts|
        accepts.html { flash[:notice] = "Successfully updated&hellip;"; redirect_to @post.is_topic? ? category_post_url(@post.category, @post) : category_post_url(:category_id => @post.category, :id => @post.topic, :anchor => "comment-#{@post.id}")  }
        accepts.js   
      end
    else
      respond_to do |accepts| 
        accepts.html { flash[:notice] = "Could not save your post&hellip;"; render :action => 'edit'  }
        accepts.js  
      end
    end
  end
  
  def destroy
    post = Post.find(params[:id])
    post.destroy
    
    if post.is_a? Topic
      redirect_to category_url(post.category)
    else
      redirect_to category_post_url(post.category, post.topic)
    end
  end
  
  private
  
  def fetch_category
    @category = Category.find(params[:category_id], :conditions => access_conditions)    
  end
  
  def spam?
    params[:verify][:nospam] != "on" or params[:verify][:spam] == "on"        
  end


end
