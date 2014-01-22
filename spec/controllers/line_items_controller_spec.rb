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

  describe "DELETE destroy" do
    before { @line_item = create(:line_item) }

    it "deletes the line_item" do
      expect{
        delete :destroy, id: @line_item
      }.to change(LineItem, :count).by(-1)
    end

    it "re-renders the cart" do
      delete :destroy, id: @line_item
      expect(response).to redirect_to cart_path
    end
  end
end
