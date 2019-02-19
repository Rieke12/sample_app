class StaticPagesController < ApplicationController
  def home
    #passes on class variable to views
    #current_user is nil in case user is not logged in,
    #if condition avoids errors
    if logged_in?
      @micropost  = current_user.microposts.build if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  def about
  end

  def contact
  end
end
