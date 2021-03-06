# encoding: utf-8
module AvatarHelper

  # Get the avatar of the given user avatar URL
  # Optionally set the size and the image title
  def avatar_tag(avatar, size = nil, title = nil)
    content_tag :span, nil,
      class: "avatar #{size ? "avatar-#{size}" : nil}",
      style: "#{%Q{background-image: url("#{avatar}")} unless avatar.blank?}",
      title: title
  end

  # Get the avatar of the given user
  def avatar_for(user, size = nil)
    avatar_tag user.avatar, size, user.name if user.is_a? User
  end
end
