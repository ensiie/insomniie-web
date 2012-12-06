#encoding: utf-8

class Trip
  include Mongoid::Document
  include Mongoid::Timestamps

  field :city
  field :date, type: Date, default: -> {Date.today}
  field :ip_address

  has_many :details, class_name: 'TripDetail', inverse_of: :trip

  before_create :fetch_details

  accepts_nested_attributes_for :details

  MUSEUM = '4bf58dd8d48988d181941735'
  ZOO = '4bf58dd8d48988d17b941735'
  CAFE = '4bf58dd8d48988d16d941735'
  FOOD = '4d4b7105d754a06374d81259'
  MONUMENT_LANDMARK = '4bf58dd8d48988d12d941735'
  CURCH = '4bf58dd8d48988d132941735'
  WINE_SHOP = '4bf58dd8d48988d119951735'
  GIFT_SHOP = '4bf58dd8d48988d128951735'
  BIKE_RENTAL = '4e4c9077bd41f78e849722f9'
  TOURIST_INFORMATION_CENTER = '4f4530164b9074f6e4fb00ff'
  TRAIN_STATION = '4bf58dd8d48988d129951735'

  def fetch_details
    # petit dej
    venue = foursquare_venues(self.city, [CAFE])['groups'][0]['items'][0]['venue']
    petit_dej = TripDetail.create({
      time: '8am',
      category: 'Petit dejeuné',
      venue_name: venue['name'],
      venue_lat: venue['location']['lat'],
      venue_lng: venue['location']['lng'],
      venue_4sq_id: venue['4f1860a7e4b0ebf9e4a3f3b6']
    })

    self.details << petit_dej
  end

  protected

  def foursquare_venues(city, categories)
    foursquare_client = Foursquare2::Client.new client_id: ENV['FOURSQUARE_CLIENT_ID'], client_secret: ENV['FOURSQUARE_CLIENT_SECRET']
    foursquare_client.explore_venues(near: city, categoryId: categories.join(','))
  end
end
