class HomeController < ApplicationController
  def top
    if !current_user.nil?
      @notifications = Notification.where(user_id: current_user.id)
      render :top_logined
    else
      @user = User.new
      render :top
    end
  end

  def condition
  end

  def register
    @user = User.new(user_params)
    if @user.save && verify_recaptcha
      authority = @user.build_authority
      authority.save
      user_traffic = @user.build_user_traffic
      user_traffic.save
      session[:user_id] = @user.id
      admin = User.find_by(user_id: "mifton")
      @user.follow(admin)
      redirect_to root_path, notice: "ユーザー「#{@user.name}を登録しました。」"
    else
      render :top_not_logined
    end
  end

  def about
  end

  def terms
  end

  def policy
  end

  def authority
    @users = User.all
  end

  private

  def user_params
    params.require(:user).permit(:name, :user_id, :email, :password, :password_confirmation)
  end

  def set_user
    @user = User.find(params[:id])
  end
end
