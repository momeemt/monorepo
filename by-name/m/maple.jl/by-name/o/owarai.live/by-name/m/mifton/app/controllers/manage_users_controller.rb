class ManageUsersController < ApplicationController
  include Common
  before_action :set_user_object, only: [:update, :destroy, :show]
  before_action :permit_admin

  # 管理画面 -> ユーザー一覧
  def index
    @q = User.all.order(id: :asc).ransack(params[:q])
    @users = @q.result(distinct: true).page(params[:page]).per(50)
  end

  # 管理画面 -> ユーザー詳細 & 編集
  def show

  end

  # 管理画面 -> ユーザー編集 (Post)
  def update

    if params[:image]
      @user.image_name = "#{@user.id}.png"
      image = params[:image]
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end

    if params[:header_image]
      @user.header_image_name = "#{@user.id}.png"
      image = params[:header_image]
      File.binwrite("public/user_images/header/#{@user.image_name}", image.read)
    end
    if params[:user]
      @user.update!(user_params)
    elsif params[:authority]
      @user.authority.update!(authority_params)
    end
    redirect_to manage_users_url
  end

  # 管理画面 -> ユーザー削除
  def destroy
    @user.destroy
    redirect_to manage_users_url
  end

  def fix_model
    user = User.find(params[:id])
    authority_model = user.build_authority
    authority_model.save
    user_traffic_model = user.build_user_traffic
    user_traffic_model.save
    redirect_back(fallback_location: root_path)
  end

  private

  def user_params
    params.require(:user).permit(
                                  :name,
                                  :user_id,
                                  :email,
                                  :password,
                                  :password_confirmation,
                                  :is_test_user,
                                  :profile,
                                  :location,
                                  :reported_value,
                                  :trusted_value,
                                  :image_name,
                                  :header_image_name
                                )
  end

  def authority_params
    params.require(:authority).permit(
      :manage_pos,
      :dev_pos,
      :donor_amount
    )
  end

  def set_user_object
    @user = User.find_by(user_id: params[:id])
  end

end
