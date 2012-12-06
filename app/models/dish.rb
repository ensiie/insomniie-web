class Dish
  include Mongoid::Document

  field :name, type: String, default: ""
  field :region, type: String, default: ""
end
