attributes :id, :date, :city, :bouffe
child details: :details do
  attributes :time, :category
  node(:venue_name){ |d| d.venue.name }
  node(:venue_lat){ |d| d.venue.lat }
  node(:venue_lng){ |d| d.venue.lng }
  node(:venue_id){ |d| d.venue.id }
  glue :venue do |v|
    child photos: :photos do
      attributes :url, :height, :width
    end
  end
end
