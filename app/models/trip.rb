#encoding: utf-8

class Trip
  include Mongoid::Document
  include Mongoid::Timestamps

  include DishHelper

  field :city
  field :date, type: Date, default: -> {Date.today}
  field :ip_address
  field :coordinates, type: Array
  field :dish

  has_many :details, class_name: 'TripDetail', inverse_of: :trip

  before_create :fetch_coordinates, :fetch_details

  accepts_nested_attributes_for :details

  BAR = '4bf58dd8d48988d116941735'
  ART = '4bf58dd8d48988d1e2931735'
  FAMOUS_MONUMENT = '4bf58dd8d48988d12d941735'
  MUSEUM = '4bf58dd8d48988d181941735'
  ZOO = '4bf58dd8d48988d17b941735'
  CAFE = '4bf58dd8d48988d16d941735'
  FOOD = '4d4b7105d754a06374d81259'
  MONUMENT_LANDMARK = '4bf58dd8d48988d12d941735'
  CHURCH = '4bf58dd8d48988d132941735'
  WINE_SHOP = '4bf58dd8d48988d119951735'
  GIFT_SHOP = '4bf58dd8d48988d128951735'
  BIKE_RENTAL = '4e4c9077bd41f78e849722f9'
  TOURIST_INFORMATION_CENTER = '4f4530164b9074f6e4fb00ff'
  TRAIN_STATION = '4bf58dd8d48988d129951735'
  HISTORIC_SITE = '4deefb944765f83613cdba6e'
  FRENCH_RESTAURANT = '4bf58dd8d48988d10c941735'
  STRIP_CLUB = '4bf58dd8d48988d1d6941735'
  PHARMACY = '4bf58dd8d48988d10f951735'

  def fetch_coordinates
    self.coordinates = Geocoder.coordinates(self.city)
  end

  def fetch_details
    cafe_venues = foursquare_venues(self.city, [CAFE]).slice(0, 5).shuffle
    information_venues = foursquare_venues(self.city, [TOURIST_INFORMATION_CENTER]).slice(0, 5).shuffle
    historic_site_venues = foursquare_venues(self.city, [MUSEUM, FAMOUS_MONUMENT]).slice(0, 5).shuffle
    restaurant_venues = foursquare_venues(self.city, [FRENCH_RESTAURANT]).slice(0, 5).shuffle
    church_venues = foursquare_venues(self.city, [CHURCH, ART, FAMOUS_MONUMENT]).slice(0, 5).shuffle
    gift_venues = foursquare_venues(self.city, [GIFT_SHOP]).slice(0, 5).shuffle
    strip_venues = foursquare_venues(self.city, [STRIP_CLUB]).slice(0, 5).shuffle
    bar_venues = foursquare_venues(self.city, [BAR]).slice(0, 5).shuffle

    # region_name = cafe_venues[0]['venue']['location']['state']
    # self.bouffe = DishHelper.get_dish_from_region(region_name).name

    self.details << TripDetail.create_from_4sq_hsh('8h', 'Petit déjeuner', cafe_venues[0]['venue'], 0) if cafe_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('9h', 'Informations', information_venues[0]['venue'], 1) if information_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('10h', 'Monument', historic_site_venues[0]['venue'], 2) if historic_site_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('12h', 'Déjeuner', restaurant_venues[0]['venue'], 3) if restaurant_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('14h', 'Monument', church_venues[0]['venue'], 4) if church_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('16h', 'Monument', historic_site_venues[1]['venue'], 5) if historic_site_venues[1]
    self.details << TripDetail.create_from_4sq_hsh('18h', 'Cadeau', gift_venues[0]['venue'], 6) if gift_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('19h', 'Repas du soir', restaurant_venues[0]['venue'], 6) if restaurant_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('22h', 'Bar', bar_venues[0]['venue'], 6) if bar_venues[0]
    self.details << TripDetail.create_from_4sq_hsh('1h', 'Nuit', strip_venues[0]['venue'], 7) if strip_venues[0]
  end

  def lat
    coordinates[0]
  end

  def lng
    coordinates[1]
  end

  protected

  def foursquare_venues(city, categories, query="")
    foursquare_client = Foursquare2::Client.new client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET']
    # raise foursquare_client.explore_venues(ll: self.coordinates.join(','), categoryId: categories.join(','), query: query, venuePhotos: 1).to_yaml
    foursquare_client.explore_venues(ll: self.coordinates.join(','), categoryId: categories.join(','), query: query, venuePhotos: 1)['groups'][0]['items']
  end
end
