#encoding: utf-8

module DishHelper
  def get_dish_from_region(region)
    Dish.where(region: region)[rand(Dish.where(region: region).count)]
  end
end
    
