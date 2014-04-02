require 'spec_helper'

feature "Unauthenticated users" do
  after(:all) { sign_out }
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

    expect(page).to have_css ".product-title", text: "Mapo Tofu"
    expect(page).to have_css ".item-total", text: "$17.98"
    expect(page.find(".quantity").value).to eq  "2"
    expect(page).to have_css "#total-price", text: "$17.98"
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
    user = create(:user, password: "password")
    create(:product, title: "Mapo Tofu", price_cents: 899)
    visit root_path

    add_css_id_to_cart("#mapo-tofu", 2)
    find("#sign-in-link").click
    find("#user_email").set(user.email)
    find("#user_password").set("password")
    page.click_button "Sign in"

    expect(page.find(".cart-link").text).to include "2 Item"
    visit cart_path
    expect(page.find(".quantity").value).to eq "2"
  end

  scenario "registring, without clearing the cart" do
    create(:product, title: "Mapo Tofu", price_cents: 899)
    visit root_path

    add_css_id_to_cart("#mapo-tofu", 2)
    find("#user-registration-link").click
    find("#user_email").set("user@example.com")
    find("#user_password").set("password")
    find("#user_password_confirmation").set("password")
    page.click_button "Sign up"

    expect(page.find(".cart-link").text).to include "2 Item"
    visit cart_path
    expect(page.find(".quantity").value).to eq "2"
  end

  scenario "attempting to view another user's cart"
  scenario "attempting to checkout without logging in"
  scenario "attempting to view administrator screens or administrator functionality"
  scenario "attempting to make themselves administrators"
end

def visit_cart
  find(".cart-link").click
end

def add_css_id_to_cart(id, qty=1)
  item = find(id)
  item.find('#line_item_quantity').set(qty.to_s) if qty > 1
  item.find(".add-cart-button").click
end

def delete_from_cart_by_css_id(id)
  find(id).find_button("Remove").click
end
