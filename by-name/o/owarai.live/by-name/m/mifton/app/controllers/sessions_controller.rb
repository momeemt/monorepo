class SessionsController < ApplicationController
  def new
    if params[:login_type] == "id"
      @login_type = "id"
    elsif params[:login_type] == "email"
      @login_type = "email"
    end
  end

  def create

    if params[:login_type] == "email"
      user = User.find_by(email: session_params[:email])
    elsif params[:login_type] == "id"
      user = User.find_by(user_id: session_params[:user_id])
    else
      user = User.find_or_create_from_auth_hash(request.env['omniauth.auth'])
      session[:user_id] = user.id
      redirect_to root_path, notice: 'ログインしました。'
      return
    end

    if user&.authenticate(session_params[:password])
      session[:user_id] = user.id

      redirect_to root_path, notice: 'ログインしました。'
    else
      render :new
    end

  end

  def destroy
    session[:user_id] = nil
    if params[:service] == "bector"
      redirect_to bector_index_url
    else
      redirect_to root_path, notice: 'ログアウトしました。'
    end
  end

  helper_method :change_login

  private

  def session_params
    params.require(:session).permit(:user_id, :email, :password)
  end
end
