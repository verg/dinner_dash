require 'spec_helper'

feature "Products" do
  scenario "logging out"
  scenario "viewing past orders" do
    it "has links to display each order"
    describe "page display a previous order" do
      it "links to each items description page"
      it "has the current status of the order"
      it "has the total order price"
      it "has the date/time the order was submitted"
      it "displays if the order was completed or cancled with a timestamp of the action"
      describe "displaying items that are retired from the menu" do
        it "still displays information about the item"
        it "cannot be added to a user's cart"
      end
    end
  end

  scenario "attempting to view another user's cart"
  scenario "attempting to view administrator screens or administrator functionality"
  scenario "attempting to make themselves administrators"
end
