class VenuesController < ApplicationController
  def show
    @venue = Venue.find params[:id]
    gon.venue = {
      lat: @venue.lat,
      lng: @venue.lng,
      name: @venue.name
    }
  end
end
