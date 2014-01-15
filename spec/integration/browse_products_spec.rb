require 'spec_helper'

feature "Products" do
  describe "Unauthenticated users" do
    scenario "browses all products" do
      create(:product, title: "Mapo Tofu", price_cents: 899)
      visit root_path
      expect(page).to have_css ".product", text: "Mapo Tofu"
    end

    scenario "browse products by category" do
      entrees = create(:category, name: "entrees")
      entrees.products.create(title: "Mapo Tofu", price_cents: 899)
      drinks = create(:category, name: "drinks")
      drinks.products.create(title: "Jasmine Tea", price_cents: 250)

      visit root_path
      click_link("Entrees")
      expect(page).to have_css ".product", text: "Mapo Tofu"
      expect(page).not_to have_css ".product", text: "Jasmine Tea"
    end

    scenario "Add products to cart"
    scenario "View cart"
    scenario "remove product from cart"
    scenario "Increase the quantity of an product in the cart"
    scenario "Logging in, without clearing the cart"
  end
end
