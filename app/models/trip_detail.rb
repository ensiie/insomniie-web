class TripDetail
  include Mongoid::Document

  belongs_to :venue
  belongs_to :trip

  field :time
  field :category

  def self.create_from_4sq_hsh(time, category, foursq_hsh)
    venue = Venue.find_or_create_by(fousq_id: foursq_hsh['id'])
    venue.update_attributes name: foursq_hsh['name'],
      coordinates: [foursq_hsh['location']['lat'], foursq_hsh['location']['lng']]
    self.create time: time,
      category: category,
      venue: venue
  end
end
