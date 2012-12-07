class ApplicationController < ActionController::Base
  include MapHelper

  protect_from_forgery

  before_filter do
    gon.geonamesUrl = geonames_url_for('monument')
  end

  rescue_from ActionController::RoutingError do
    redirect_to root_path
  end
end
