class Photo
  include Mongoid::Document

  field :width, type: Integer
  field :height, type: Integer
  field :url

  belongs_to :venue
end
