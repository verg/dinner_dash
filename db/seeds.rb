# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
entrees = Category.create(name: "Entrees")
drinks = Category.create(name: "Drinks")
entrees.products.create(title: "Mapo Tofu", price_cents: 899, display_rank: 3)
drinks.products.create(title: "Jasmine Tea", price_cents: 150, display_rank: 6)
