class BectorChannel < ApplicationCable::Channel
  def subscribed
    stream_from "bector:micropost"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def micropost
    @micropost = current_user.microposts.build(m_params)
    if @micropost.save
      tag_array = params[:micropost][:tags].split(/[[:blank:]]+/);
      tag_array.each do |tag|
        @tag = @micropost.tags.build
        @tag.name = tag
        @tag.save
      end
    end
  end

end
