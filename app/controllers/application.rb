# Filters added to this controller will be run for all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
class ApplicationController < ActionController::Base
  before_filter :login
    
  protected
    
  def load_forum
    @forum = Forum.find(params[:forum])
    if not @forum
      raise StandardError, "unknown forum"
    end
  end
    
  def access_denied
    flash[:error] = "You do not have the required user level to perform the action #{controller_name}::#{action_name}"
    redirect_to '/'
    return false
  end
  
  def login
    user =  session[:user] || login_from_cookie
    
    if user       
      @user = User.auth(user.email, user.password)
    end
  end
  
  def login_from_cookie
    if cookies[:token]  
      return session[:user] = User.find_by_token(cookies[:token]) 
    end
    nil 
  end
  
  def access_conditions    
    'access_level <= ' << (@user.nil? ? 0 : @user.level).to_i.to_s
  end  
  
  def require_super_user
    access_denied unless @user and @user.level >= 1024
  end

  def require_admin
    access_denied unless @user and @user.level >= 128
  end

  def require_moderator
    access_denied unless @user and @user.level >= 64
  end

end