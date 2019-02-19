class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  include SessionsHelper

  private
    
    #confirm a logged-in user
    #returns a String if user not logged in, nil if user logged in
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        #returns <html><body>You are being <a href="http://localhost:3000/login">redirected</a>.</body></html>
        redirect_to login_url
      end
    end
end
