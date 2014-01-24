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

    scenario "Adding to and browsing cart" do
      create(:product, title: "Mapo Tofu", price_cents: 899)
      visit root_path

      2.times { add_css_id_to_cart("#mapo-tofu") }
      expect(page.find(".cart-link").text).to include "$17.98"
      visit_cart

      expect(page).to have_css ".product", text: "Mapo Tofu"
      expect(page).to have_css ".item-price", text: "$17.98"
      expect(page.find(".quantity").value).to eq  "2"
      expect(page).to have_css ".total-price", text: "$17.98"
    end

    scenario "remove product from cart" do
      create(:product, title: "Mapo Tofu", price_cents: 899)
      create(:product, title: "Soup", price_cents: 499)
      visit root_path

      add_css_id_to_cart("#mapo-tofu")
      add_css_id_to_cart("#soup")
      visit_cart

      expect(page.find("#mapo-tofu").find(".quantity").value).to eq  "1"
      delete_from_cart_by_css_id("#mapo-tofu")

      expect(page).not_to have_css("#mapo-tofu")
      expect(page).to have_css("#soup")
    end

    scenario "Increase the quantity of a product in the cart" do
      create(:product, title: "Mapo Tofu", price_cents: 899)
      visit root_path

      add_css_id_to_cart("#mapo-tofu", 2)
      visit_cart

      expect(page.find(".quantity").value).to eq "2"
      page.find(".quantity").set("4")
      page.find(".update-quantity-button").click
      expect(page.find(".quantity").value).to eq "4"
    end

    scenario "Logging in, without clearing the cart" do
      create(:product, title: "Mapo Tofu", price_cents: 899)
      visit root_path

      add_css_id_to_cart("#mapo-tofu", 2)
    end
  end

  def visit_cart
    find(".cart-link").click
  end

  def add_css_id_to_cart(id, qty=1)
    item = find(id)
    item.find('.quantity-input').set(qty.to_s) if qty > 1
    item.find(".add-cart-button").click
  end

  def delete_from_cart_by_css_id(id)
    find(id).find_button("Remove").click
  end
end
