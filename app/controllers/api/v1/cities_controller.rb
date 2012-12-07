require "open-uri"

class Api::V1::CitiesController < Api::V1::ApiV1Controller
  include MapHelper
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
    results = get_region_of_city()
    render json: results
  end
end
