class Friend
  include Mongoid::Document

  belongs_to :user

  field :facebook_id
  field :name
  field :city

  def url
    "https://graph.facebook.com/#{facebook_id}/picture?type=large"
  end
end
