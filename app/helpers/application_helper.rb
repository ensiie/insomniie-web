# encoding: utf-8

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

  def amazon_products_for(collection, keywords)
    results = Hash.from_xml(
      VACUUM.get(
        query: {
          'Operation'       => 'ItemSearch',
          'SearchIndex'     => 'Books',
          'Keywords'        => keywords,
          'ResponseGroup'   => 'ItemAttributes,OfferSummary,Images'
        }
      ).body
    )
    items = results['ItemSearchResponse']['Items']['Item']
    return [] if items.blank?
    items = [items] unless items.is_a?(Array)
    items.inject([]) do |memo, item|
      price = item.try(:[], 'OfferSummary').try(:[], 'LowestNewPrice').try(:[], 'Amount')

      if price
        item_attributes = item['ItemAttributes']
        if item_attributes
          author = item_attributes['Author']
          author = author.to_sentence if author.is_a?(Array)
          title = item_attributes['Title']
        end

        image = item['ImageSets']
        if image
          image = image['ImageSet']
          image = image.first if image.is_a?(Array)
          image = image['MediumImage']['URL']
        end

        memo << {
          title: title,
          author: author,
          url: item['DetailPageURL'],
          price: number_to_euros(price.to_f / 100.0),
          image: image
        }
      else
        memo
      end
    end
  end

  def amazon_books_for(keywords)
    amazon_products_for 'Books', keywords
  end

  def number_to_euros(number)
    number_to_currency(
      number,
      unit: '€',
      separator: ',',
      delimiter: '',
      format: "%n %u"
    )
  end
end
