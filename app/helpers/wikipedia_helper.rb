# encoding: utf-8
require 'open-uri'

module WikipediaHelper
  include GoogleSearchHelper

  # Load the page preview from Wikipedia that
  # corresponds to the given title
  def get_preview_from_wikipedia_for(title)
    wikipedia_hash = Hash.from_xml(open("http://fr.wikipedia.org/w/api.php?action=opensearch&limit=1&namespace=0&format=xml&search=#{URI.escape(title)}").read)
    return {} unless (wikipedia_hash = wikipedia_hash['SearchSuggestion']['Section'])
    wikipedia_hash = wikipedia_hash['Item']
    {
      title: wikipedia_hash['Text'],
      description: wikipedia_hash['Description'],
      url: wikipedia_hash['Url'],
      small_image: wikipedia_hash['Image'].try(:[], 'source'),
      large_image: get_image_from_google_for(title)
    }
  end
end
