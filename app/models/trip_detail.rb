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

  def self.create_from_4sq_hsh(time, category, foursq_hsh)
    self.create time: time,
      category: category,
      venue_name: foursq_hsh['name'],
      venue_lat: foursq_hsh['location']['lat'],
      venue_lng: foursq_hsh['location']['lng'],
      venue_4sq_id: foursq_hsh['id']
  end
end
