# encoding: utf-8
require 'open-uri'

module GoogleSearchHelper

  # Load results from Google Search API and parse it
  # to get the first link for the given keywords
  def get_link_from_google_for(keywords, type = nil)
    json = open("https://www.googleapis.com/customsearch/v1?key=#{ENV["GOOGLE_SEARCH_API_KEY"]}&cx=#{ENV["GOOGLE_SEARCH_API_CX"]}&q=#{URI.escape(keywords)}#{"&searchType=image" if type == :image}&prettyPrint=false&num=1").read
    results = JSON.parse json
    results["items"][0]["link"]
  end

  # Load results from Google Search API and parse it
  # to get the first image link for the given keywords
  def get_image_from_google_for(keywords)
    get_link_from_google_for keywords, :image
  rescue Exception
    ''
  end
end
