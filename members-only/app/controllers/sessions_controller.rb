class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash[:success] = "Welcome!"
      sign_in user
      redirect_to root_path      
    else
      flash.now[:danger] = "Invalid login"
      render 'new'
    end
  end
  
  def destroy
    sign_out current_user
    flash[:success]= "Logged out"
    redirect_to root_path
  end
  
end
