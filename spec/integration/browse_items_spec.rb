require 'spec_helper'

feature "Items" do
  describe "Unauthenticated users" do
    scenario "browses all items" do
      create(:item, title: "Mapo Tofu", price_cents: 899)
      visit root_path
      expect(page).to have_css ".item", text: "Mapo Tofu"
    end

    scenario "browse items by category" do
      entrees = create(:category, name: "entrees")
      entrees.items.create(title: "Mapo Tofu", price_cents: 899)
      drinks = create(:category, name: "drinks")
      drinks.items.create(title: "Jasmine Tea", price_cents: 250)

      visit root_path
      click_link("Entrees")
      expect(page).to have_css ".item", text: "Mapo Tofu"
      expect(page).not_to have_css ".item", text: "Jasmine Tea"
    end

    scenario "Add items to cart"
    scenario "View cart"
    scenario "remove item from cart"
    scenario "Increase the quantity of an item in the cart"
    scenario "Logging in, without clearing the cart"
  end
end
