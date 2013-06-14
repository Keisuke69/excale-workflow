class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :logged_in?

  def logged_in?
    if session[:user].blank?
        return if params[:controller] == "login"
        redirect_to :controller => "login" , :action => "index"
    else
        @login_user = session['user']
        @login_user_role = session['user_role']
    end
  end
end
