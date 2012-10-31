module AdminAuthentication

  def admin_required
    return true if logged_in?
    flash[:error] = 'Unauthorized entry'
    redirect_to '/'
    return false
  end
  
  def admin_login(pw)
    if pw == PersonalInformation::AdminPassword
      session[:admin] = true
    end
  end
  
  def logged_in?
    session[:admin]
  end
  
  def admin_logout
    session[:admin] = nil
  end  
  
  #add these functions as a helper method to any including library
  #(since the including library is the parent controller, it gets added
  #as a helper function who's scope is any controller!)
  def self.included(base)
    begin
      base.send(:helper_method, :logged_in?)
    rescue #I don't care if the class doesn't have helper methods
    end
  end
end
