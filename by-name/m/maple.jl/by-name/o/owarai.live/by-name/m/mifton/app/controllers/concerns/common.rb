module Common
  extend ActiveSupport::Concern

  included do
    # ここにcallback等
  end

  # メソッド
  def permit_admin
    unless current_user
      redirect_to root_path
      return
    end
    redirect_to root_path if current_user.authority.manage_pos == "general"
  end

  private


end
