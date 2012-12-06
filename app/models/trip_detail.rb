class TripDetail
  include Mongoid::Document

  belongs_to :venue
  belongs_to :trip

  field :time
  field :category
  field :venue_name
  field :venue_lat
  field :venue_lng
  field :venue_icon
end
