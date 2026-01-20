module BectorHelper

  def login?
    !current_user.nil?
  end

  def date_display(created_at)
    seconds = (Time.now - created_at).round
    minutes = hours = datas = 0
    while true
      if seconds >= 60
        seconds -= 60
        minutes += 1
      elsif minutes >= 60
        minutes -= 60
        hours += 1
      elsif hours >= 24
        hours -= 24
        datas += 1
      else
        break
      end
    end

    if datas >= 8
      created_at.strftime("%Y年%m月%d日")
    elsif datas != 0
      "#{datas}日前"
    elsif hours != 0
      "#{hours}時間前"
    elsif minutes != 0
      "#{minutes}分前"
    else
      "#{seconds}秒前"
    end
  end

  def reactioned? (post,type)
    Reaction.find_by(user_id: current_user.id, reactioned_id: post.id, reactioned_type: type)
  end

  def reaction_count (post,type)
    Reaction.where(reactioned_id: post.id, reactioned_type: type).count
  end

  def tags_to_array (tags)
    tags_arr = tags.split
  end
end
