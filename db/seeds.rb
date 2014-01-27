# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)
[Category, Product, LineItem].each { |model| model.destroy_all }

entrees = Category.create!(name: "Entrees")
drinks = Category.create!(name: "Drinks")
soups = Category.create!(name: "Soups")
appetizers = Category.create!(name: "Appetizers")

entrees.products.create!(title: "Mapo Tofu", price_cents: 899, display_rank: 3)
drinks.products.create!(title: "Jasmine Tea", price_cents: 150, display_rank: 6)
appetizers.products.create!(title: "Dan Dan Noodles", price_cents: 499, display_rank: 5)

hot_pot = Product.create!(title: "Hot Pot", price_cents: 1699, display_rank: 3)
entrees.products << hot_pot
soups.products << hot_pot
