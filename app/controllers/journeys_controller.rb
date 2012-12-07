class JourneysController < ApplicationController
  def show
    @journey = Trip.new
    @journey.ip_address = request.remote_ip
    @journey.city = params[:trip][:city]
    @journey.save
    @region = get_region_of_city(@journey.city)[:region]
    @details = @journey.details.map do |step|
      venue = step.venue
      {
        time: step.time,
        category: step.category,
        name: venue.name,
        lat: venue.lat,
        lng: venue.lng
      }
    end
    gon.trip = {
      lat: @journey.lat,
      lng: @journey.lng,
      details: @details
    }
  end
end
