class Poi
  include Mongoid::Document
  include Tire::Model::Search
  include Tire::Model::Callbacks

  field :name
  field :coordinates, type: Array

  mapping do
    indexes :name
    indexes :ll, type: 'geo_point'
  end

  def ll
    coordinates.join(',')
  end

  def ll=(val)
    self.coordinates = val.split(',').map(&:strip)
  end

  def self.search(params)
    tire.search(load: true) do
      # query { string params[:q] } if params[:q]
      query { all }
      filter :geo_distance, ll: params[:ll].split(','), distance: '10km' if params[:ll].present?
    end
  end

  def self.paginate(options = {})
     page(options[:page]).per(options[:per_page])
  end
end
