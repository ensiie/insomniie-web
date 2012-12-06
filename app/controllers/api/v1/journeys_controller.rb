class Api::V1::JourneysController < Api::V1::ApiV1Controller
  def show
    @journey = Trip.new
    @journey.ip_address = request.remote_ip
    @journey.city = params['city']
    @journey.save
  end
end
