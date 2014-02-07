require 'spec_helper'

describe OrderSearch do
  let(:searcher) { OrderSearch.new }

  describe "#search" do
    it "returns orders for all Users matching the search term on any user attribute" do
      bob = create(:user, firstname: "Bob", lastname: "James", email: "funguy@gmail.com")
      alice = create(:user, firstname: "Alice", lastname: "James", email: "alice@gmail.com")
      other_guy = create(:user, firstname: "Other", lastname: "Guy", email: "guy@yahoo.com")

      bob_order = create(:order, user: bob)
      alice_order = create(:order, user: alice)
      other_order = create(:order, user: other_guy)

      lastname_results = searcher.search(search_by_user_query: "James")
      expect(lastname_results).to include(alice_order, bob_order)
      expect(lastname_results).not_to include(other_order)

      firstname_results = searcher.search(search_by_user_query: "Bob")
      expect(firstname_results).to include(bob_order)
      expect(firstname_results).not_to include(alice_order, other_order)

      email_results = searcher.search(search_by_user_query: "funguy@gmail.com")
      expect(email_results).to include(bob_order)
      expect(email_results).not_to include(alice_order, other_order)
    end

    it "filters by status" do
      complete_order = create(:order, complete: true)
      paid_order = create(:order, paid: true)

      lastname_results = searcher.search(order_status: :paid )
      expect(lastname_results).to include(paid_order)
      expect(lastname_results).not_to include(complete_order)
    end

    it "filters by both status and a search term" do
      bob = create(:user, firstname: "Bob", lastname: "James", email: "funguy@gmail.com")
      alice = create(:user, firstname: "Alice", lastname: "James", email: "alice@gmail.com")
      other_guy = create(:user, firstname: "Other", lastname: "Guy", email: "guy@yahoo.com")

      complete_order = create(:order, user: bob, complete: true)
      paid_order = create(:order, user: alice, paid: true)
      other_order = create(:order, user: other_guy)

      lastname_results = searcher.search(search_by_user_query: "James", order_status: :paid )
      expect(lastname_results).to include(paid_order)
      expect(lastname_results).not_to include(other_order, complete_order)
    end
  end
end
