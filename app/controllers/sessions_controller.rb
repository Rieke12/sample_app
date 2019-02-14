class SessionsController < ApplicationController
  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      #Log the user in and redirect to user's show page
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      redirect_back_or @user
    else
      #render doesn't count as loading new page, so flash would persist
      #flash.now won't persist
      flash.now[:danger] = "Invalid email/password combination"
      render 'new'
    end
  end

  def destroy
    #avoids exception when logging out twice accidentally
    log_out if logged_in?
    redirect_to root_url
  end
end
