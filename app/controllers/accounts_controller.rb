class AccountsController < ApplicationController
  before_filter :require_admin, :only => [:destroy]


  def index                
    @user = User.new(params[:user])
    
    if request.post? 
      
      if user = User.find_by_email_and_password(@user.email,@user.password)

        if params[:remember] == 'on'
          cookies[:token]  = { :value => user.token, :expires => 3.months.from_now } 
        end
      
        session[:user] = user
        flash[:notice] = "Welcome #{user.name}"
        redirect_to params[:return_to] || index_url
        return
      end        
      
      flash[:notice] = "Invalid login."
    end
  end
  
  def new
    # Add condition here if you want to disable or restrict the registration of new users
    if false
      redirect_to index_url and return
    end
    
    @user = User.new(params[:user])   
  end

  def create
    @user = User.new(params[:user])   
    
    # First user created is a superuser
    @user.level = User.count > 0 ? 0 : 1024

    if verify_recaptcha and @user.save      
      flash[:notice] = "Successfully created user #{@user.name}&hellip;"
      session[:user] = @user
      
      redirect_to index_url
    else
      render :action => 'new'
    end    
  end
  
  def update
    @user.attributes = params[:user]

    if @user.save
      flash[:notice] = "Successfully updated user #{@user.name}&hellip;"
      session[:user] = @user
      
      redirect_to index_url
    else
      flash[:error] = "Could not save user: #{@user.errors.full_messages}"
      redirect_to :action => 'edit'
    end
  end
  
  def logout
    session[:user] = nil
    cookies[:token]  = { :value => '', :expires => Time.at(0) } 
    redirect_to index_url
  end
  
  def password_recovery
    
    if request.post?
      
      if user = User.find_by_email(params[:user][:email])
        UserMailer.deliver_recover(user, request.host)
        render :update do |page|
          page.call 'Flash.notice', "The password has been sent to <u>#{user.email}</u>&hellip;"
        end
      else
        render :update do |page|
          page.call 'Flash.error', "The email address you specified is not registered!"          
        end
      end
    end
    
  end
  
  def destroy
    @deleted_user = User.find(params[:id])
    @deleted_user.destroy
    respond_to do |accepts|
      accepts.html { flash[:notice] = "Removed user #{@deleted_user.name}&hellip;"; redirect_to index_url }
      accepts.js   
    end
  end
  

end
