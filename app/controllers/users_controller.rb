class UsersController < ApplicationController
  before_filter :require_admin, :only => [:create_user]

  def show
    @user_details = User.find(params[:id])
  end
  
  def list
    
    conditions = nil
    if params[:access]
      conditions = ["level >= ?", params[:access].to_i]
    end
    
    @users = User.paginate(:limit => 50, :page => params[:page], :conditions => conditions, :order => "name ASC")  
  end
  
  
  def update
    @user_details = User.find(params[:id])
    
    if params[:user][:level]
      require_super_user
      @user_details.level = params[:user][:level]
      @user_details.save
      render :update do |page|
        page.call 'Flash.notice', "User <u>#{@user_details.name}</u> updated&hellip;"
      end  
    elsif params[:user][:title]
      require_super_user
      @user_details.title = params[:user][:title]
      @user_details.save
      render :update do |page|
        page.call 'Flash.notice', "User <u>#{@user_details.name}</u> updated&hellip;"
        page.replace_html 'user-title-name', @user_details.title
        page.call 'Opinion.togglePair', 'user-title', 'user-title-edit'
        page.visual_effect :highlight, "user-title"
      end  
    else     
      @user_details.attributes = params[:user]
      if @user_details.save
        flash[:notice] = "Updated your profile&hellip;" 
        redirect_to index_url
      else
        flash[:notice] = "Could not update your profile&hellip;"        
        render :action => 'show', :id => @user_details
      end
    end
  end
  
  def create_user
    @newuser = User.build(params[:newuser])
    case(params[:level])
    when 'Moderator':
      @newuser.level = 64
    when 'Administrator':
      @newuser.level = 128
    else
      @newuser.level = 0
    end
    @newuser.save
  end

  def gravatar
  end


end
