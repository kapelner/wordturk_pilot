class WelcomeController < ApplicationController
  include AdminAuthentication

  def index
    #handle previously logged in
    if logged_in?
      redirect_to :controller => :admin
    elsif request.post?
      if admin_login(params[:pw])
        redirect_to :controller => :admin
      else
        flash[:error] = 'Wrong Password'
      end
    end
    #otherwise, just render the vanilla html
  end

end
