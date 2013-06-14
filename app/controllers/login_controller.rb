require 'digest' 

class LoginController < ApplicationController
  # GET /logins
  # GET /logins.json
  def index
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @logins }
    end
  end

  # GET /logins/1
  # GET /logins/1.json
  def auth

    encrypted = Digest::SHA256.hexdigest(params['password'])
    user = User.find(:first,:conditions => ["user = ? or password = ? ",params['user'],encrypted])


    respond_to do |format|
      if user
        #session
          session[:user] = user.user
          session[:user_role] = user.role
          format.html { redirect_to :controller => "applications",:action => "index" }
      else
          format.html { render :action => "index" , notice: 'Login error.'}
      end

    end
  end

  def logout

    reset_session
    redirect_to :action => "index"
  end
end
