module UsersHelper

  def authority_to_sentence (auth)
    return_sentence = ""
    if auth == "admin"
      return_sentence = "ADR (管理責任者)"
    elsif auth == "staff"
      return_sentence = "AD (管理者)"
    elsif auth == "trust_user"
      return_sentence = "MUser (優良ユーザー)"
    else
      return_sentence = "一般ユーザー"
    end
    return_sentence
  end

  def authority_star (auth,name)
    if auth == "admin"
      return "☆" + name
    end
  end
end
