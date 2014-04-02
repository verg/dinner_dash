require 'spec_helper'

feature "administrators" do
  before(:all) { find("#sign-out-link").click if page.has_css?("#sign-out-link") }
  scenario "creating item listsings includings a name, description, price and photo" do
    sign_in_admin
    expect(page).to have_content "Dashboard"
    page.find("#new-product-link").click
    fill_in "Title", with: "Pho"
    fill_in "Price", with: "5.00"
    fill_in "Description", with: "A tasty treat!"
    attach_file "product_photo", File.join(Rails.root, '/spec/fixtures/soup_image.jpeg')
    click_button "Submit"

    expect(page).to have_content "Dashboard"
  end

  scenario "creating categories" do
    sign_in_admin
    create_category("Apps")
    expect(page).to have_content "Apps"
  end

  def create_category(name="CategoryName")
    page.find("#new-category-link").click
    fill_in "Name", with: "Apps"
    click_button "Submit"
  end

  scenario "modifing an existing item" do
    tea = create(:product, title: "Tea", price_cents: 299)
    drinks = create(:category, name: "Drinks")
    sign_in_admin

    find("#edit_product_#{tea.id}_link").click
    fill_in "Title", with: "Jasmine Tea"
    fill_in "Price", with: "2.09"
    fill_in "Description", with: "The tastiest!"
    find(:css, "#product_category_ids_#{drinks.id}").set(true)
    fill_in "Display rank", with: 4
    click_button "Submit"

    click_link("Jasmine Tea")
    expect(page).to have_content "Jasmine Tea"
    expect(page).to have_content "2.09"
    expect(page).to have_content "The tastiest!"
    expect(page).to have_content "4"
    expect(page).to have_content "Drinks"

    visit dashboard_path
    find("#edit_product_#{tea.id}_link").click
    find(:css, "#product_category_ids_#{drinks.id}").set(true)
    choose("No") # set Available to false
    click_button "Submit"

    find("#retired-products-link").click
    expect(page).to have_content "Jasmine Tea"
  end

  scenario "assigning and removing items to categories" do
    tea = create(:product, title: "Tea", price_cents: 899)

    drinks = create(:category, name: "Drinks")
    sign_in_admin

    find("#edit_category_#{drinks.id}_link").click
    find(:css, "#category_product_ids_#{tea.id}").set(true)
    find("#category-submit-button").click
    click_link "Drinks"
    expect(page).to have_content "Tea"

    visit dashboard_path
    find("#edit_category_#{drinks.id}_link").click
    find(:css, "#category_product_ids_#{tea.id}").set(false)
    find("#category-submit-button").click
    click_link "Drinks"
    expect(page).not_to have_content "Tea"
  end

  scenario "logging out" do
    sign_in_admin
    page.find("#sign-out-link").click
    visit dashboard_path
    expect(page).not_to have_content "Dashboard"
  end
end

feature "admin dashboard" do
  before(:all) { find("#sign-out-link").click if page.has_css?("#sign-out-link") }
  before { Order.destroy_all }

  scenario "viewing orders" do
    order = create(:order)
    quantity = order.line_items.reduce(0) {|sum, item| sum + item.quantity }

    sign_in_admin
    expect(page).to have_css("#order-#{order.id}-link")
    find("#mark-paid-button").click
    expect(page).to have_content("Status: Paid")

    find("#mark-complete-button").click
    expect(page).to have_content("Status: Complete")

    find("#cancel-button").click
    expect(page).to have_content("Status: Canceled")

    find(".edit-order-link").click
    find(".quantity-input").set(quantity + 1)

    click_button "Update Order"
    find(".edit-order-link").click
    expect(find(".quantity-input").value).to match (quantity + 1).to_s
  end
end

def sign_in_admin(admin = create(:admin, password: "password"))
  visit new_admin_session_path
  fill_in "Email",  with: admin.email
  fill_in "Password",  with: "password"
  click_button "Sign in"
end
