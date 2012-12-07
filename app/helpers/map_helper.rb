# encoding: utf-8
require 'open-uri'

module MapHelper

  # Get the Geonames API service URL from keywords
  def geonames_url_for(keywords)
    "http://api.geonames.org/searchJSON?q=#{URI.escape(keywords)}&maxRows=50&username=#{ENV['GEONAMES_USERNAME']}"
  end

  # Get the results of the Geonames API from keywords
  def geonames_for(keywords)
    results = JSON.parse open(geonames_url_for(keywords)).read
    if geonames = results['geonames']
      geonames
    else
      results
    end
  end

  def get_region_of_city(city)
    if city
      url = "http://maps.google.com/maps/api/geocode/json?address=#{URI.escape(city)}&components=country:FR&sensor=false"
      json = JSON.parse open(url).read
      {region: json["results"][0]["address_components"][2]["long_name"]}
    else
      {}
    end
  end
end
