module ManagesHelper

  def than_trust_user
    if !current_user.nil?
      auth = current_user.authority.manage_pos
      dev = current_user.authority.dev_pos
      if auth == "trust_user" || auth == "operator" || auth == "admin" || dev == "developer"
        return true
      end
    end
    false
  end

  def than_operator
    if !current_user.nil?
      auth = current_user.authority.manage_pos
      dev = current_user.authority.dev_pos
      if auth == "operator" || auth == "admin" || dev == "developer"
        return true
      end
    end
    false
  end

  def than_admin
    if !current_user.nil?
      auth = current_user.authority.manage_pos
      dev = current_user.authority.dev_pos
      if auth == "admin" || dev == "developer"
        return true
      end
    end
    false
  end

  def login?
    return !current_user.nil?
  end

end
