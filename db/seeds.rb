# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create!([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create!(name: 'Emanuel', city: cities.first)
unless Rails.env.production?
  [Category, Product, LineItem].each { |model| model.destroy_all }

  entrees = Category.create!(name: "Entrees")
  drinks = Category.create!(name: "Drinks")
  soups = Category.create!(name: "Soups")
  appetizers = Category.create!(name: "Appetizers")

  photo = File.open(Rails.root + 'spec/fixtures/soup_image.jpeg')
  entrees.products.create!(title: "Mapo Tofu", price_cents: 899, display_rank: 3, photo: photo)
  drinks.products.create!(title: "Jasmine Tea", price_cents: 150, display_rank: 6, photo: photo)
  appetizers.products.create!(title: "Dan Dan Noodles", price_cents: 499, display_rank: 5, photo: photo)

  hot_pot = Product.create!(title: "Hot Pot", price_cents: 1699, display_rank: 3, photo: photo)
  entrees.products << hot_pot
  soups.products << hot_pot

user_email = "user@example.com"
  unless User.find_by(email: user_email)
    User.create!(firstname: "bob", lastname: "user", email: user_email,
                 password: "password")
  end

 admin_email = "admin@example.com"
  unless Admin.find_by(email: admin_email)
    Admin.create!(email: admin_email, password: "password")
  end
end
