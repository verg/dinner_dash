require 'spec_helper'

feature "non-admin users" do
  scenario "logging out" do
    sign_in
    find("#sign-out-link").click
    expect(page).to have_css("#sign-in-link")
  end

  feature "past orders" do
    scenario "viewing past orders" do
      sign_in user = create(:user)
      order_1 = create(:order, user: user, status: "paid")
      order_2 = create(:order, user: user, status: "completed")

      visit root_path
      find("#orders-link").click
      expect(page).to have_css("#order-#{order_1.id}")
      expect(page).to have_css("#order-#{order_2.id}")

      find("#order-#{order_1.id}").find('.order-details-link').click
      expect(page).to have_css ".order-status", text: "Paid"
      expect(page.find(".total-order-price").text).to include order_1.total_price.to_s
      expect(page).to have_css ".order-placed-time"
      expect(page).to have_css ".item-description"

      find("#orders-link").click
      find("#order-#{order_2.id}").find('.order-details-link').click
      expect(page).to have_css ".order-status", text: "Completed at"
    end

    scenario "displays if the order was completed or cancled with a timestamp of the action"
    scenario "displaying items that are retired from the menu"
    # it "still displays information about the item"
    # it "cannot be added to a user's cart"
  end
  scenario "attempting to view another user's cart"
  scenario "attempting to view administrator screens or administrator functionality"
  scenario "attempting to make themselves administrators"
end

def sign_in(user = create(:user, password: "password"))
  visit root_path
  find("#sign-in-link").click
  find("#user_email").set(user.email)
  find("#user_password").set("password")
  page.click_button "Sign in"
end

def add_css_id_to_cart(id, qty=1)
  item = find(id)
  item.find('.quantity-input').set(qty.to_s) if qty > 1
  item.find(".add-cart-button").click
end

def visit_cart
  find(".cart-link").click
end

def check_out
  visit_cart
  page.find("#checkout-link").click
  click_button "Pay with Card"

  find("#user_email").set(user.email)
  find(".numberInput").set(user.email)
  find(".expiresInput").set(user.email)
  find(".cvcInput").set(user.email)
  click_button(/Pay/)
end
