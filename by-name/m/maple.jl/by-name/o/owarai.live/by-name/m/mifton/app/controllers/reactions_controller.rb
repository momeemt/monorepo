class ReactionsController < ApplicationController

  def create

    has_same_reaction = Reaction.where(
      user_id: current_user.id,
      reactioned_id: params[:reactioned_id],
      reactioned_type: params[:reactioned_type]
    )

    if has_same_reaction
      @reaction = Reaction.new(
        user_id: current_user.id,
        reactioned_id: params[:reactioned_id],
        reactioned_type: params[:reactioned_type]
      )

      @reaction.save
      post = Micropost.find_by(
        id: params[:reactioned_id]
      )

      unless post.user_id == current_user.id
        user = User.find(post.user_id)
        @notification = user.notifications.build(
          kind: "reaction",
          is_public: false,
          target: post.id,
          from_user: current_user.id,
          from_service: "bector"
        )
        search_object = Notification.where(
          kind: "reaction",
          is_public: false,
          target: post.id,
          from_user: current_user.id,
          from_service: "bector"
        )
        is_already_exist = search_object.present?
        unless is_already_exist
          @notification.save
        end
      end

      @post_id = params[:post_id]
      @user = params[:user]

      respond_to do |format|
        format.html { redirect_back(fallback_location: root_path) }
        format.js
      end
    end

  end

  def destroy
    @reaction = Reaction.find_by(
      user_id: current_user.id,
      reactioned_id: params[:reactioned_id],
      reactioned_type: params[:reactioned_type]
    )
    @reaction.destroy

    post = Micropost.find_by(
      id: params[:reactioned_id]
    )

    unless post.user_id == current_user.id
      search_object = Reaction.where(
        user_id: current_user.id,
        reactioned_id: params[:reactioned_id]
      )
      is_exist = search_object.present?
      unless is_exist
        @notification = Notification.find_by(
          kind: "reaction",
          is_public: false,
          target: post.id,
          from_user: current_user.id,
          from_service: "bector"
        )
        if @notification.present?
          @notification.destroy
        end
      end
    end

    @post_id = params[:post_id]
    @user = params[:user_data]

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
      format.js
    end

    #redirect_back(fallback_location: root_path)
  end

  private

end
