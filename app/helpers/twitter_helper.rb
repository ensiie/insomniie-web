# encoding: utf-8
module TwitterHelper
  include Twitter::Autolink

  TWITTER_MAX_ATTEMPTS = 3

  # Safely get the tweets from the given block
  def application_tweets
    # Disable tweets if Twitter env config do not exist
    return [] unless ENV['TWITTER_CONSUMER_KEY'] and ENV['TWITTER_CONSUMER_SECRET']

    num_attempts = 0
    begin
      num_attempts += 1
      yield
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
