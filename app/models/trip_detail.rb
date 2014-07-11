class TripDetail
  include Mongoid::Document

  belongs_to :venue
  belongs_to :trip

  field :time
  field :category
  field :position

  default_scope asc(:position)

  def self.create_from_4sq_hsh(time, category, foursq_hsh, pos)
    venue = Venue.find_or_create_by(fousq_id: foursq_hsh['id'])
    venue.update_attributes name: foursq_hsh['name'],
      coordinates: [foursq_hsh['location']['lat'], foursq_hsh['location']['lng']]
    if items = foursq_hsh.try(:[], 'photos').try(:[], 'groups').try(:[], 0).try(:[], 'items')
      venue.update_attributes photos_attributes: (items.map{ |ph|
        {
          height: ph['user']['photo']['height'],
          width: ph['user']['photo']['width'],
          url: "#{ph['user']['photo']['prefix']}#{ph['user']['photo']['suffix']}"
        }
      })
    end
    self.create time: time,
      category: category,
      venue: venue,
      position: pos
  end
end
