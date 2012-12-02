class ApplicationController < ActionController::Base
  include MapHelper

  protect_from_forgery

  before_filter do
    gon.geonamesUrl = geonames_url_for('monument')
  end
end
