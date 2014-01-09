require 'spec_helper'

feature "Items" do
  scenario "Unauthenticated user browses all items" do
    mapo = create(:item, title: "Mapo Tofu")

    visit root_path

    expect(page).to have_css ".item", text: "Mapo Tofu"
  end
end
