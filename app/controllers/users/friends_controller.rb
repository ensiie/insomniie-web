class Users::FriendsController < ApplicationController
  prepend_before_filter :authenticate_user!

  layout false

  def index
    graph = Koala::Facebook::API.new(current_user.fb_access_token)
    friends = graph.get_connections("me", "friends", fields: 'name,location')
    friends.each do |fa|
      f = current_user.friends.find_or_create_by(facebook_id: fa['id'])
      f.update_attributes name: fa['name']
      if fa['location']
        f.update_attributes city: fa['location']['name']
      end
    end
    @friends = current_user.friends.where(:city.ne => nil)
  end
end
