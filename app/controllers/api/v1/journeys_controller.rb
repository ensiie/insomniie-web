class Api::V1::JourneysController < Api::V1::ApiV1Controller
  def show
    # @journey = Trip.find_or_create_by(city: params['city'])
    @journey = Trip.create(city: params['city'])
  end
end
