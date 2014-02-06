require 'spec_helper'

describe OrderSearch do
  describe ".by_user_attributes" do
    it "returns orders for all Users matching the search term on any user attribute" do
      bob = create(:user, firstname: "Bob", lastname: "James", email: "funguy@gmail.com")
      alice = create(:user, firstname: "Alice", lastname: "James", email: "alice@gmail.com")
      other_guy = create(:user, firstname: "Other", lastname: "Guy", email: "guy@yahoo.com")

      bob_order = create(:order, user: bob)
      alice_order = create(:order, user: alice)
      other_order = create(:order, user: other_guy)

      lastname_results = OrderSearch.by_user_attributes("James")
      expect(lastname_results).to include(alice_order, bob_order)
      expect(lastname_results).not_to include(other_order)

      firstname_results = OrderSearch.by_user_attributes("Bob")
      expect(firstname_results).to include(bob_order)
      expect(firstname_results).not_to include(alice_order, other_order)

      email_results = OrderSearch.by_user_attributes("funguy@gmail.com")
      expect(email_results).to include(bob_order)
      expect(email_results).not_to include(alice_order, other_order)
    end
  end
end
