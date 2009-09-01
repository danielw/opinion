class AdminController < ApplicationController
  before_filter :require_super_user 
  
  def index
    @superusers = User.find(:all, :conditions => "level = 1024")
    @admins     = User.find(:all, :conditions => "level = 128")
    @moderators = User.find(:all, :conditions => "level = 64")
  end
  
  def new_user
    render :partial => 'new_user'
  end
  
  def create_user
    @newuser = User.new(params[:newuser])
    @newuser.level = params[:newuser][:level]
    @newuser.save
  end  
  
  protected
    
  def access_denied
    session[:return_to] = { :controller => controller_name, :action => action_name }
    redirect_to :controller => "accounts"
    return false
  end

end
