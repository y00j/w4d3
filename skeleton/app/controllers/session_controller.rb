class SessionController < ApplicationController
  #verify user_name/password
  #reset the user's

  def new
    render :new
  end

  def create
    temp_params = user_params(params)
    user_password = temp_params[:password]
    user_name = temp_params[:username]
    @user = User.find_by_credentials(user_name, user_password)
    if @user
      @user.reset_session_token!
      session[:session_token] = @user.session_token
      redirect_to cats_url
    else

      redirect_to new_session_url
    end
  end


  def user_params(params)
    params.require(:user).permit(:username, :password)
  end

  def destroy
    if current_user
      current_user.reset_session_token!
      session[:session_token] = nil
    
    end
  end



end
