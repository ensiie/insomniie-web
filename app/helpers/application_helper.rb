module ApplicationHelper
  include Twitter::Autolink

  TWITTER_MAX_ATTEMPTS = 3

  def avatar_tag(avatar, size = nil, title = nil)
    content_tag :span, nil,
      class: "avatar #{size ? "avatar-#{size}" : nil}",
      style: "#{%Q{background-image: url("#{avatar}")} unless avatar.blank?}",
      title: title
  end

  def avatar_for(user, size = nil)
    avatar_tag user.avatar, size, user.name if user.is_a? User
  end

  def application_tweets
    num_attempts = 0
    begin
      num_attempts += 1
      Twitter.home_timeline
    rescue Twitter::Error::TooManyRequests => error
      if num_attempts <= TWITTER_MAX_ATTEMPTS
        # NOTE: Your process could go to sleep for up to 15 minutes but if you
        # retry any sooner, it will almost certainly fail with the same exception.
        sleep error.rate_limit.reset_in
        retry
      else
        raise
      end
    end
  end
end
