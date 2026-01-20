class RelationshipsController < ApplicationController
  def create
    user = User.find(params[:followed_id])
    current_user.follow(user)

    @notification = user.notifications.build(
      kind: "follow",
      is_public: false,
      target: nil,
      from_user: current_user.id,
      from_service: "mifton"
    )
    @notification.save

    if params[:service] == "Bector"
      redirect_to "/bector/users/#{user.user_id}"
    else
      redirect_to "/#{user.user_id}"
    end
  end

  def destroy
    user = Relationship.find(params[:id]).followed
    current_user.unfollow(user)

    @notification = Notification.find_by(
      kind: "follow",
      is_public: false,
      target: nil,
      from_user: current_user.id,
      from_service: "mifton"
    )
    @notification.destroy

    if params[:service] == "Bector"
      redirect_to "/bector/users/#{user.user_id}"
    else
      redirect_to "/#{user.user_id}"
    end
  end
end
