require 'spec_helper'

feature "Items" do
  describe "Unauthenticated users" do
    scenario "browses all items" do
      mapo = create(:item, title: "Mapo Tofu")
      visit root_path
      expect(page).to have_css ".item", text: "Mapo Tofu"
    end

    scenario "browse items by category"

    scenario "Add items to cart"
    scenario "View cart"
    scenario "remove item from cart"
    scenario "Increase the quantity of an item in the cart"
    scenario "Logging in, without clearing the cart"
  end
end
