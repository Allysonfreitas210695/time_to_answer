module UsersBackofficeHelper
  def avatar_url
    avatar = current_user.user_profile.avatar
    avatar.attached? ? avatar : 'profile.svg'
  end

  def gender_select(msg_user)
    msg_format(msg_user)
  end

  private

  def msg_format(msg)
    case msg
      when 'F'
        'Feminino'
      when 'M'
        "Masculino"
      else
        ""
      end
  end
end
