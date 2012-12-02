# encoding: utf-8
module AmazonProductHelper

  # Load product results as XML from Amazon
  # Product Adverstising API, and turn it into
  # a ruby hash
  def load_amazon_products_hash(collection, keywords)
    Hash.from_xml(
      VACUUM.get(
        query: {
          'Operation'       => 'ItemSearch',
          'SearchIndex'     => collection,
          'Keywords'        => keywords,
          'ResponseGroup'   => 'ItemAttributes,OfferSummary,Images'
        }
      ).body
    )
  end

  # Get Amazon product array from the query on
  # collection with keywords, where each result item
  # is the corresponding item attributes
  def amazon_products_for(collection, keywords)
    amazon_results = load_amazon_products_hash(collection, keywords)
    amazon_product_array_from(amazon_results).inject([]) do |memo, item|
      if item_attributes = item_attributes_from(item)
        memo << item_attributes
      else
        memo
      end
    end
  rescue Exception
    []
  end

  # Get the Amazon books that correspond to
  # the search keywords
  def amazon_books_for(keywords)
    amazon_products_for 'Books', keywords
  end


  private

  # Turn a number into euros string
  def number_to_euros(number)
    number_to_currency(
      number,
      unit: '€',
      separator: ',',
      delimiter: '',
      format: "%n %u"
    )
  end

  # Extract product array from Amazon loaded
  # result hash
  def amazon_product_array_from(amazon_results)
    items = amazon_results['ItemSearchResponse']['Items']['Item']
    return [] if items.blank?
    items = [items] unless items.is_a?(Array)
    items
  end

  # Extract Amazon product attributes from
  # API-loaded result hash
  def item_attributes_from(item)
    price = item.try(:[], 'OfferSummary').try(:[], 'LowestNewPrice').try(:[], 'Amount')
    return nil unless price
    item_attributes = item['ItemAttributes']
    if item_attributes
      author = get_author_from_amazon_item_attributes(item_attributes)
      title = item_attributes['Title']
    end
    image = get_image_from_amazon_item(item)
    {
      title: title,
      author: author,
      url: item['DetailPageURL'],
      price: number_to_euros(price.to_f / 100.0),
      image: image
    }
  end

  # Get the author of Amazon item attributes
  def get_author_from_amazon_item_attributes(item_attributes)
    author = item_attributes['Author']
    author = author.to_sentence if author.is_a?(Array)
  end

  # Get the author of Amazon item
  def get_image_from_amazon_item(item)
    image = item['ImageSets']
    if image
      image = image['ImageSet']
      image = image.first if image.is_a?(Array)
      image = image['LargeImage']['URL']
    end
  end
end
