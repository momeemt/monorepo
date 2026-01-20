class UsersController < ApplicationController
  before_action :set_user, only: [:update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save && verify_recaptcha
      authority = @user.build_authority
      user_traffic = @user.build_user_traffic

      if authority.save && user_traffic.save
        session[:user_id] = @user.id
        admin = User.find_by(user_id: "mifton")
        @user.follow(admin)
        redirect_to "/", notice: "ユーザー「#{@user.name}を登録しました。」"
      else
        render action: :new
      end
    else
      render action: :new
    end
  end

  def destroy
    @user.destroy
    redirect_to users_url
  end

  def show
    @user = User.find_by(user_id: params[:id])
  end

  def edit
    if current_user.nil?
      redirect_to root_path
      return
    end
    @user = current_user

    if current_user.user_birthday.present?
      @user_birthday = current_user.user_birthday
    end
  end

  def update
    current_user.update!(user_params)
    current_user.user_traffic.update!(user_traffic_params)

    if current_user.user_birthday.present?
      current_user.user_birthday.update!(user_birthdays_params)
    else
      current_user.create_user_birthday(user_birthdays_params)
    end

    redirect_to "/users/edit"
  end

  def exit
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :user_id, :password, :password_confirmation, :icon, :header)
  end

  def user_traffic_params
    params.require(:user).permit(
      :profile,
      :location,
      :user_link,
      :twitter_id,
      :lobi_id,
      :github_id,
      :discord_id
    )
  end

  def user_birthdays_params
    params.require(:user).permit(
      :birthday,
      :publish_years,
      :publish_date
    )
  end

  def set_user
    @user = User.find_by(user_id: params[:id])
  end

end
