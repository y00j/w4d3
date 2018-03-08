class UsersController < ApplicationController

  def new
    # @user = User.new
    render :new
  end

  def create
    #pull username/password from params
    # debugger
    @user = User.new(user_params(params))

    if @user.save
      redirect_to cats_url
    else
      render :new
    end

  end



  private

  def user_params(params)
    params.require(:user).permit(:username, :password)
  end
end
