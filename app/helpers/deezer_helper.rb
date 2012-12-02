# encoding: utf-8
require 'open-uri'

module DeezerHelper

  # Load results from Google Search API and parse it
  # to get the first link for the given keywords
  def get_tracks_from_deezer_for(keywords)
    json = open("https://api.deezer.com/2.0/search?q=#{URI.escape(keywords)}").read
    results = JSON.parse json
    results["data"].map do |item|
      {
        artist: item["artist"]["name"],
        title: item["title"],
        album: item["album"]["title"],
        link: item["link"],
        preview: item["preview"]
      }
    end
  end
end
