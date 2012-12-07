class Api::V1::VenuesController < Api::V1::ApiV1Controller
  include WikipediaHelper

  def wikipedia
    results = get_preview_from_wikipedia_for(params[:search])
    render json: results
  end
end
