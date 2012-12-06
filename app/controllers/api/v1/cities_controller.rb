require "open-uri"

class Api::V1::CitiesController < Api::V1::ApiV1Controller
  def autocomplete
    if params[:city]
      url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=#{URI.escape(params[:city])}&key=AIzaSyByTB4eGDkbLpmj-Mu5bpNfccvi3hSXm4c&sensor=true&components=country:fr&types=(cities)"
      json = JSON.parse open(url).read
      results = json["predictions"].map do |item|
        item["terms"][0]["value"]
      end
    else
      results = []
    end
    render json: {cities: results}
  end

  def region
    if params[:city]
      url = "http://maps.google.com/maps/api/geocode/json?address=#{URI.escape(params[:city])}&components=country:FR&sensor=false"
      json = JSON.parse open(url).read
      results = {region: json["results"][0]["address_components"][2]["long_name"]}
    else
      results = {}
    end
    render json: results
  end
end
