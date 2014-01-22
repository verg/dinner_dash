require 'spec_helper'

describe LineItemsController do
  describe "POST #create" do
    before { request.env["HTTP_REFERER"] = "/" }

    it "creates a new line item if none exists for that user session & product" do
      expect{
        post :create, product: attributes_for(:product)
      }.to change(LineItem, :count).by(1)
    end

    it "increments a line item count if one already exists for that user session & product" do
      line_item = LineItem.create(quantity: 1, product_id: 1)
      cart = double("current_cart",
                    find_or_create_line_item_by_product_id: line_item)
      @controller.stub(:current_cart).and_return(cart)

      expect{
        post :create, product_id: 1
      }.to change(line_item, :quantity).by(1)
    end
  end
end
