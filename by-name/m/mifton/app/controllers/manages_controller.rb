class ManagesController < ApplicationController
  include Common
  before_action :permit_admin

  def debug
    log_arr =  File.open('log/development.log').readlines
    @logs = Kaminari.paginate_array(log_arr.reverse).page(params[:page]).per(400)
  end

  def fix
    users = User.all
    users.each do |user|
      if user.authority.nil?
        auth = user.build_authority
        auth.save
      end

      if user.user_traffic.nil?
        tra = user.build_user_traffic
        tra.save
      end
    end
  end

  private

end
