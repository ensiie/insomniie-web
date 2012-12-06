class JourneysController < ApplicationController
  def show
    @journey = Trip.new
    @journey.ip_address = request.remote_ip
    @journey.city = params[:trip][:city]
    @journey.save
  end
end
