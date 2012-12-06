# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

file = YAML.load_file(Rails.root.to_s + "/data/plats.yml")
file.each do |r|
  r.each_pair do |region,dishes|
    dishes.each do |dish|
      puts "Add " + dish + " (" + region + ")"
      Dish.create name: dish, region: region
    end
  end
end

